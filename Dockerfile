# Use PHP 8.2 CLI
FROM php:8.2-cli

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev zip \
    && docker-php-ext-install zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# 🔥 Force rebuild (important for Render cache)
RUN echo "force rebuild $(date)"

# 🔥 Regenerate autoload (important)
RUN composer dump-autoload

# 🔥 Clear Laravel caches
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan cache:clear

# Set permissions (safe)
RUN chmod -R 777 storage bootstrap/cache

# Expose port
EXPOSE 10000

# Start Laravel using Render PORT
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-10000}