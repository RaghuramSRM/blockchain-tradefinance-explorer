<?php
/**
 * Lightweight JWT & Security Handler
 * Implements HMAC SHA-256 tokens and Password Hashing
 */

class JWT {
    private static function getSecretKey(): string {
        $secretKey = getenv('JWT_SECRET');
        if ($secretKey !== false && $secretKey !== '') {
            return $secretKey;
        }

        if (getenv('APP_ENV') === 'production') {
            throw new RuntimeException('JWT_SECRET must be configured in production');
        }

        return hash('sha256', __FILE__);
    }

    public static function encode(array $payload, int $expirySeconds = 3600): string {
        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
        $payload['iat'] = time();
        $payload['exp'] = time() + $expirySeconds;
        $payload['iss'] = 'ChainDocs-Auth-Service';
        $payload['aud'] = 'ChainDocs-Ecosystem';

        $base64UrlHeader = self::base64UrlEncode($header);
        $base64UrlPayload = self::base64UrlEncode(json_encode($payload));
        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, self::getSecretKey(), true);
        $base64UrlSignature = self::base64UrlEncode($signature);

        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }

    public static function decode(string $token): ?array {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }

        [$headerB64, $payloadB64, $sigB64] = $parts;
        $sig = self::base64UrlDecode($sigB64);
        $expectedSig = hash_hmac('sha256', $headerB64 . "." . $payloadB64, self::getSecretKey(), true);

        if (!hash_equals($expectedSig, $sig)) {
            return null; // Invalid signature
        }

        $payload = json_decode(self::base64UrlDecode($payloadB64), true);
        if (!$payload || !isset($payload['exp']) || $payload['exp'] < time()) {
            return null; // Expired or malformed
        }

        return $payload;
    }

    private static function base64UrlEncode(string $data): string {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private static function base64UrlDecode(string $data): string {
        return base64_decode(strtr($data, '-_', '+/') . str_repeat('=', 3 - (3 + strlen($data)) % 4));
    }
}
