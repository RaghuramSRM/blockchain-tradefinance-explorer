FROM php:8.3-cli

RUN apt-get update \
    && apt-get install -y --no-install-recommends libsqlite3-dev \
    && docker-php-ext-install pdo_sqlite \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

ENV APP_ENV=production
ENV DB_DRIVER=sqlite
ENV SQLITE_PATH=/tmp/chaindocs.sqlite

CMD ["sh", "-c", "php -S 0.0.0.0:${PORT:-10000} -t /app /app/router.php"]
