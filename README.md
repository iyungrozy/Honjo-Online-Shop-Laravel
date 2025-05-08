# Docker Laravel Development Environment

This repository contains a Docker-based Laravel development environment that allows you to run Laravel without relying on local Windows environments like Laragon.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- Git (optional, for version control)

## Port Configuration

This environment uses custom ports to avoid conflicts with other services:

- **Web Server**: Port 7890 (http://localhost:7890)
- **MySQL Database**: Port 7891 (for connecting with external tools)

## Installation

### New Installation

1. Clone this repository (or download it)

```
git clone <repository-url> online-shop
cd online-shop
```

2. Start the Docker environment

```
docker-compose up -d
```

3. The environment comes with Laravel pre-installed. If you need to make any changes to dependencies, you can run:

```
docker-compose exec app composer install
```

4. Configure your environment by copying the .env.example file (if it's not already set up):

```
docker-compose exec app cp .env.example .env
```

5. Generate application key (if not already generated):

```
docker-compose exec app php artisan key:generate
```

6. Run database migrations:

```
docker-compose exec app php artisan migrate
```

7. Access your application at [http://localhost:7890](http://localhost:7890)

### Using on Another Computer

1. Ensure Docker Desktop is installed on the target computer
2. Clone/copy the project to the target computer
3. Navigate to the project directory
4. Run `docker-compose up -d` to start the environment
5. Follow steps 3-7 from the "New Installation" section

## Common Commands

### Environment Management

- Start environment: `docker-compose up -d`
- Stop environment: `docker-compose down`
- View logs: `docker-compose logs`
- Rebuild containers: `docker-compose build`

### Laravel Commands

Run these commands from your host machine:

- Run Artisan commands: `docker-compose exec app php artisan <command>`
- Run Composer: `docker-compose exec app composer <command>`
- Run NPM (if needed): `docker-compose run --rm npm <command>`
- Run database migrations: `docker-compose exec app php artisan migrate`

### Database Access

#### From Laravel Application

The Laravel `.env` file should have these settings:

```
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret
```

#### From External Tools

- Host: localhost (or 127.0.0.1)
- Port: 7891
- Database: laravel
- Username: laravel
- Password: secret
- Root Password: secret

## Container Management

### Access Container Shell

- PHP/Laravel container: `docker-compose exec app bash`
- MySQL container: `docker-compose exec mysql bash`
- Nginx container: `docker-compose exec nginx sh`

### View Container Status

```
docker-compose ps
```

## Development Workflow

1. Edit code in the `src` directory using your preferred code editor
2. Changes are immediately reflected in the running application
3. Run artisan/composer commands as needed
4. Access the application at http://localhost:7890

## Troubleshooting

### Port Conflicts

If you encounter port conflicts, edit the `docker-compose.yml` file to change:
- Web port (currently 7890)
- MySQL port (currently 7891)

### Permissions Issues

If you encounter permission issues with files created inside containers:
```
docker-compose exec app chown -R www-data:www-data /var/www/html/storage
```

### Container Won't Start

Check for port conflicts or other errors:
```
docker-compose logs
```

## Additional Information

- PHP Version: 8.2
- MySQL Version: 8.0
- Nginx: Latest Alpine version

This environment is completely isolated from your local Windows environment, allowing for consistent development across different machines.

