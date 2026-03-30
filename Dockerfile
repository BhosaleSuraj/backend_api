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

# Install dependencies (optimized)
RUN composer install --no-dev --optimize-autoloader

# Clear Laravel caches
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan cache:clear

# Expose port (Render uses dynamic PORT)
EXPOSE 10000

# Start Laravel server using Render PORT
CMD php artisan serve --host=0.0.0.0 --port=$PORT