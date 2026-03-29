# Use PHP 8.2 CLI image
FROM php:8.2-cli

# Set working directory
WORKDIR /app

# Copy all project files into container
COPY . .

# Install system dependencies and zip PHP extension
RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev zip \
    && docker-php-ext-install zip

# Copy composer from official composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install

# Expose port
EXPOSE 10000

# Start Laravel development server
CMD php artisan serve --host=0.0.0.0 --port=10000