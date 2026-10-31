<?php
/**
 * ChainDocs Router for PHP built-in web server
 */

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// 1. Route API requests to the API gateway
if (strpos($uri, '/api') === 0) {
    require __DIR__ . '/api/index.php';
    exit;
}

// 2. Serve static frontend files (html, css, js, images)
$frontendPath = __DIR__ . '/frontend' . $uri;

if ($uri !== '/' && file_exists($frontendPath) && !is_dir($frontendPath)) {
    // Determine content type
    $ext = pathinfo($frontendPath, PATHINFO_EXTENSION);
    $mimes = [
        'html' => 'text/html',
        'css'  => 'text/css',
        'js'   => 'application/javascript',
        'json' => 'application/json',
        'png'  => 'image/png',
        'jpg'  => 'image/jpeg',
        'svg'  => 'image/svg+xml',
        'ico'  => 'image/x-icon',
        'pdf'  => 'application/pdf'
    ];
    if (isset($mimes[$ext])) {
        header('Content-Type: ' . $mimes[$ext]);
    }
    readfile($frontendPath);
    exit;
}

// 3. Serve root
if ($uri === '/' || $uri === '/index.html') {
    header('Content-Type: text/html');
    readfile(__DIR__ . '/frontend/index.html');
    exit;
}

// 4. Try appending .html
if (file_exists($frontendPath . '.html')) {
    header('Content-Type: text/html');
    readfile($frontendPath . '.html');
    exit;
}

// 5. 404 fallback
http_response_code(404);
echo "404 Not Found: " . htmlspecialchars($uri);
