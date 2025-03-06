FROM dunglas/frankenphp AS build

# Argumentos para o usuário
ARG user=marcelo
ARG uid=1000

# Instalar dependências do sistema e ferramentas necessárias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    gnupg \
    ca-certificates \
    lsb-release \
    nginx \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensões PHP necessárias para Laravel
RUN docker-php-ext-install pdo_mysql mysqli mbstring exif pcntl bcmath gd sockets intl zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Criar usuário para rodar a aplicação
RUN useradd -u $uid -G www-data,root -m -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Instalar Redis PHP extension
RUN pecl install -o -f redis && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis

# Copiar código do Laravel para a pasta do servidor
COPY . /var/www

# Definir permissões corretas
RUN chown -R $user:www-data /var/www

# Copiar arquivos de configuração do PHP
COPY resources/docker/php/app.ini /usr/local/etc/php/conf.d/app.ini
COPY resources/docker/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Expor portas HTTP e HTTPS
EXPOSE 80 443

# Definir diretório de trabalho
WORKDIR /var/www

# Trocar para usuário não-root para segurança
USER $user

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]
