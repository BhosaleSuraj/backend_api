# Use PHP 8.2 CLI
FROM php:8.2-cli

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev zip \
    && docker-php-ext-install zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# 🔥 IMPORTANT: create .env if missing
RUN cp .env.example .env || true

# 🔥 Generate key (important)
RUN php artisan key:generate

# 🔥 Clear caches
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan cache:clear

# 🔥 Force rebuild
RUN echo "build $(date)"

# Permissions
RUN chmod -R 777 storage bootstrap/cache

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=${PORT:-10000}