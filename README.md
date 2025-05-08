# Docker Laravel Development Environment

This repository contains a Docker-based Laravel development environment that allows you to run Laravel without relying on local Windows environments like Laragon. The setup is designed to be cross-platform compatible and includes automation scripts for both Windows and Unix-based systems.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- Git (optional, for version control)

## Port Configuration

This environment uses custom ports to avoid conflicts with other services:

- **Web Server**: Port 7890 (http://localhost:7890)
- **MySQL Database**: Port 7891 (for connecting with external tools)

## Installation

### Quick Setup Using Scripts

This project includes setup scripts for both Windows and Unix-based systems to automate the installation process:

#### For Windows:

Run the following command in PowerShell:

```powershell
.\setup.ps1
```

#### For macOS/Linux:

Run the following command in Terminal:

```bash
chmod +x setup.sh
./setup.sh
```

These scripts will:
- Create necessary directories
- Set up proper permissions
- Start Docker containers
- Install Laravel dependencies
- Configure environment variables
- Run database migrations
- Ensure proper permissions for storage directories

### Manual Installation

If you prefer to set up manually, follow these steps:

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

7. Set proper permissions for storage directories:

```
docker-compose exec -u root app chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
docker-compose exec -u root app chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
```

8. Access your application at [http://localhost:7890](http://localhost:7890)

### Using on Another Computer

1. Ensure Docker Desktop is installed on the target computer
2. Clone/copy the project to the target computer
3. Navigate to the project directory
4. Use the appropriate setup script for your OS or follow the manual installation steps above

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

After changing ports, restart the containers:
```
docker-compose down
docker-compose up -d
```

### Permissions Issues

This setup uses named volumes to manage persistent storage for Laravel and avoid permission issues. However, if you encounter permission problems, you can run the following commands:

#### Fix Laravel Storage Permissions
```
docker-compose exec -u root app chown -R www-data:www-data /var/www/html/storage
docker-compose exec -u root app chown -R www-data:www-data /var/www/html/bootstrap/cache
docker-compose exec -u root app chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
```

#### Fix Database Permissions (if using SQLite)
```
docker-compose exec -u root app chown -R www-data:www-data /var/www/html/database
docker-compose exec -u root app chmod 664 /var/www/html/database/database.sqlite
```

#### Clear Laravel Caches
```
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan view:clear
docker-compose exec app php artisan config:clear
```

### Container Won't Start

Check for port conflicts or other errors:
```
docker-compose logs
```

### Healthcheck Failures

The containers include healthchecks to ensure services are running properly. If containers are restarting:

1. Check container health status:
```
docker-compose ps
```

2. View specific container logs:
```
docker-compose logs app
docker-compose logs nginx
docker-compose logs mysql
```

### Issues on Windows

If you encounter issues with file permissions or line endings on Windows:

1. Ensure Docker Desktop is set to use Linux containers
2. Check that you have proper permissions for the project directory
3. If necessary, run the setup script with administrative privileges
4. Configure Git to handle line endings properly:
```
git config --global core.autocrlf input
```

## Volume Persistence and Data Management

This setup uses Docker named volumes for persistent data storage:

- `laravel-storage`: Stores Laravel storage files (logs, cache, etc.)
- `laravel-bootstrap-cache`: Stores Laravel bootstrap cache
- `mysql-data`: Stores MySQL database files
- `composer-cache`: Stores Composer cache to speed up dependency installation

These volumes persist even when containers are removed. To completely remove all data and start fresh:

```
docker-compose down -v
```

## Additional Information

### Technical Specifications
- PHP Version: 8.2
- MySQL Version: 8.0
- Nginx: Latest Alpine version

### Design Considerations
- **Cross-platform compatibility**: Works on Windows, macOS, and Linux
- **Isolated environment**: Completely isolated from your local environment
- **Persistent storage**: Named volumes ensure data persistence between container restarts
- **Automatic permissions**: Setup scripts handle permissions automatically
- **Healthchecks**: Containers include health monitoring
- **Security**: Configuration follows best practices for development environments

### Setup Scripts
The included setup scripts (`setup.sh` and `setup.ps1`) automate the environment configuration process:

- Verify Docker installation and status
- Create necessary directory structure
- Set proper file permissions
- Initialize containers
- Install dependencies
- Configure environment variables
- Set up database
- Optimize Laravel

This environment is designed to provide a consistent development experience across different machines, ensuring that "it works on my machine" becomes "it works on everyone's machine."
