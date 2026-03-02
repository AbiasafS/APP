# 1. Usamos una imagen base que ya trae PHP y Apache instalados sobre Debian
FROM php:8.2-apache

# 2. Actualizamos el índice de paquetes e instalamos extensiones comunes 
# (Aquí replicamos los comandos 'apt-get install' que usamos en Azure)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql

# 3. Habilitamos módulos de Apache (como mod_rewrite) si es necesario
RUN a2enmod rewrite

# 4. Copiamos el código de tu aplicación local a la carpeta de Apache en el contenedor
# Asegúrate de tener una carpeta 'src' o tus archivos .php en el mismo nivel que el Dockerfile
COPY ./src /var/www/html/

# 5. Ajustamos los permisos para que Apache pueda leer los archivos
RUN chown -R www-data:www-data /var/www/html

# 6. Exponemos el puerto 80 (el estándar para HTTP)
EXPOSE 80