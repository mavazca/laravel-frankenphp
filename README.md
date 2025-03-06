# Projeto Laravel com Octane e FrankenPHP

Este projeto utiliza Laravel Octane e FrankenPHP para otimizar o desempenho da aplicação em produção, rodando com PHP 8.4.

---

## 1. Pré-requisitos

Antes de começar, você precisará garantir que as seguintes dependências estejam instaladas:

- **PHP 8.4 ou superior**
- **Composer** (para gerenciar dependências do Laravel)
- **Laravel Octane** (para otimização do desempenho)
- **FrankenPHP** (para servidor de alto desempenho)
- **Banco de dados** (MySQL, PostgreSQL ou outro de sua escolha)
- **Redis** (para cache, sessões e filas, se necessário)

---

## 2. Configuração do Ambiente

### Criar e configurar o arquivo `.env`

Após o deploy do projeto, configure o arquivo `.env` com os parâmetros adequados para o ambiente de produção.

Exemplo de `.env`:

```env
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:KgF/sMAtO33GVTa7D1xGnULoacZo7HVearKVcfgaOnw=
APP_DEBUG=true
APP_URL=http://localhost

APP_LOCALE=en
APP_FALLBACK_LOCALE=en
APP_FAKER_LOCALE=en_US

APP_MAINTENANCE_DRIVER=file
# APP_MAINTENANCE_STORE=database

PHP_CLI_SERVER_WORKERS=4

BCRYPT_ROUNDS=12

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel_frankenphp
DB_USERNAME=laravel_frankenphp
DB_PASSWORD=root

SESSION_DRIVER=redis
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=redis

CACHE_STORE=redis
# CACHE_PREFIX=

MEMCACHED_HOST=127.0.0.1

REDIS_CLIENT=phpredis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=log
MAIL_SCHEME=null
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

VITE_APP_NAME="${APP_NAME}"

OCTANE_SERVER=frankenphp
OCTANE_WORKERS=8
OCTANE_HTTPS=false
```

- **APP_KEY:** Gere uma chave para o Laravel com o comando:

```bash
php artisan key:generate
```
- **DB_CONNECTION:** Ajuste de acordo com o banco de dados utilizado (mysql, pgsql, etc.).
- **CACHE_DRIVER, SESSION_DRIVER, QUEUE_CONNECTION:** Configure para redis ou outro driver adequado.
- **OCTANE_SERVER:** Defina frankenphp como o servidor de execução.

---

## 3. Instalar as Dependências

Após configurar o ambiente, instale as dependências do Laravel com:

```bash
composer install --optimize-autoloader --no-dev
```
Esse comando instalará todas as bibliotecas necessárias, otimizando a autoload para produção.

---

## 4. Rodar as Migrações

Após instalar as dependências, execute as migrações do banco de dados para criar as tabelas:

```bash
php artisan migrate --force
```
- O flag --force é necessário para rodar as migrações em produção sem necessidade de confirmação.

---

## 5. Gerar o Cache de Configuração

Para melhorar o desempenho da aplicação, gere o cache das configurações e das rotas:

```bash
php artisan optimize
```

---

## 6. Iniciar o Octane com FrankenPHP

Agora, inicie o servidor Octane utilizando FrankenPHP:

```bash
php artisan octane:start --server=frankenphp
```
Esse comando rodará a aplicação com alta performance, utilizando a tecnologia de FrankenPHP para otimização.

Caso queira rodar em background, utilize:

```bash
nohup php artisan octane:start --server=frankenphp > storage/logs/octane.log 2>&1 &
```
Para verificar se o serviço está rodando:

```bash
php artisan octane:status
```

---

## 7. Verificar os Logs

Acompanhe os logs da aplicação para garantir que está rodando corretamente e detectar possíveis erros:

```bash
tail -f storage/logs/laravel.log
```
Se estiver rodando Octane em background, verifique o log com:

```bash
tail -f storage/logs/octane.log
```

---

## 8. Manutenção e Deploy em Produção

### **Atualizar o código**

Sempre que atualizar o código da aplicação, siga estes passos:

```bash
git pull origin main
composer install --optimize-autoloader --no-dev
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan octane:reload
```

O comando php artisan octane:reload reinicia os workers do Octane sem precisar parar o servidor.

### **Reiniciar o Octane manualmente**

Caso precise reiniciar o Octane manualmente, utilize:

```bash
php artisan octane:stop
php artisan octane:start --server=frankenphp
```
### **Limpar o cache**

Se precisar limpar o cache por algum motivo, execute:

```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

### **Configuração de Supervisão (Opcional)**
Caso queira garantir que o Laravel Octane sempre reinicie após uma falha ou reinício do servidor, utilize o **Supervisor** no Linux.

Instale o Supervisor:

```bash
sudo apt-get install supervisor
```

Crie um arquivo de configuração para o Supervisor:

```bash
sudo nano /etc/supervisor/conf.d/laravel-octane.conf
```
Adicione o seguinte conteúdo:

```ini
[program:octane]
command=php artisan octane:start --server=frankenphp
directory=/caminho/do/seu/projeto
autostart=true
autorestart=true
stderr_logfile=/var/log/octane.err.log
stdout_logfile=/var/log/octane.out.log
user=www-data
```

Salve e recarregue o Supervisor:

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start octane
```

Agora, o Octane será automaticamente reiniciado caso pare de funcionar.

---

## 9. Considerações Finais

Após seguir todos os passos acima, sua aplicação Laravel estará rodando de forma otimizada com Octane e FrankenPHP.

### **Boas práticas para produção:**

- Acompanhe os logs para identificar possíveis erros.
- Utilize Redis para cache, sessões e filas para melhor desempenho.
- Ajuste o número de workers de acordo com a demanda (OCTANE_WORKERS no .env).
- Utilize Supervisor para garantir que o Octane reinicie automaticamente.

Para mais informações, consulte as documentações oficiais:

- [Laravel Octane](https://laravel.com/docs/12.x/octane)
- [FrankenPHP](https://frankenphp.dev)
