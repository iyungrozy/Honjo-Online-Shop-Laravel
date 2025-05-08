#!/bin/bash

# ===================================================
# Laravel Docker Environment Setup Script
# ===================================================
# This script sets up the Docker-based Laravel environment
# with proper permissions and initial configuration.
# ===================================================

# Colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Laravel Docker Environment Setup${NC}"
echo -e "${BLUE}========================================${NC}"

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

echo -e "${GREEN}Step 1: Creating required directories...${NC}"
# Create required directories if they don't exist
mkdir -p src/storage/app/public
mkdir -p src/storage/framework/cache
mkdir -p src/storage/framework/sessions
mkdir -p src/storage/framework/testing
mkdir -p src/storage/framework/views
mkdir -p src/bootstrap/cache

echo -e "${GREEN}Step 2: Setting up initial permissions...${NC}"
# Set permissions (this will be used by Docker)
if [[ "$OSTYPE" == "darwin"* || "$OSTYPE" == "linux-gnu"* ]]; then
    # macOS or Linux
    chmod -R 777 src/storage
    chmod -R 777 src/bootstrap/cache
    echo -e "${GREEN}Permissions set successfully.${NC}"
else
    # Windows or other
    echo -e "${YELLOW}Warning: Running on Windows. Please ensure your Docker for Windows has proper volume sharing configured.${NC}"
fi

echo -e "${GREEN}Step 3: Checking if Laravel is already installed...${NC}"
# Check if Laravel is already installed by looking for vendor directory
if [ -d "src/vendor" ]; then
    echo -e "${YELLOW}Laravel seems to be already installed. Skipping installation.${NC}"
else
    echo -e "${GREEN}Setting up fresh Laravel installation...${NC}"
    # Laravel not installed yet, set up .env file after containers are up
    NEED_FRESH_INSTALL=true
fi

echo -e "${GREEN}Step 4: Starting Docker containers...${NC}"
# Start Docker containers
docker-compose up -d

# Wait for containers to be ready
echo -e "${YELLOW}Waiting for containers to be ready...${NC}"
sleep 10

# If we need a fresh Laravel installation
if [ "$NEED_FRESH_INSTALL" = true ]; then
    echo -e "${GREEN}Step 5: Installing Laravel dependencies...${NC}"
    # Install dependencies
    docker-compose exec app composer install --no-interaction --no-progress

    echo -e "${GREEN}Step 6: Setting up .env file...${NC}"
    # Set up .env file
    docker-compose exec app cp -n .env.example .env
    
    echo -e "${GREEN}Step 7: Generating application key...${NC}"
    # Generate application key
    docker-compose exec app php artisan key:generate

    echo -e "${GREEN}Step 8: Setting up database...${NC}"
    # Run migrations
    docker-compose exec app php artisan migrate --force
    
    echo -e "${GREEN}Step 9: Optimizing application...${NC}"
    # Optimize
    docker-compose exec app php artisan optimize
    
    echo -e "${GREEN}Step 10: Setting final permissions...${NC}"
    # Set final permissions
    docker-compose exec -u root app chown -R www-data:www-data /var/www/html/storage
    docker-compose exec -u root app chown -R www-data:www-data /var/www/html/bootstrap/cache
    docker-compose exec -u root app chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
else
    echo -e "${GREEN}Step 5: Refreshing configuration...${NC}"
    # Just refresh configuration
    docker-compose exec app php artisan optimize
    
    echo -e "${GREEN}Step 6: Setting permissions...${NC}"
    # Set permissions
    docker-compose exec -u root app chown -R www-data:www-data /var/www/html/storage
    docker-compose exec -u root app chown -R www-data:www-data /var/www/html/bootstrap/cache
    docker-compose exec -u root app chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Setup completed successfully!${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${YELLOW}Your Laravel application is now running at:${NC}"
echo -e "${GREEN}http://localhost:7890${NC}"
echo -e ""
echo -e "${YELLOW}MySQL database is available at:${NC}"
echo -e "${GREEN}Host: localhost${NC}"
echo -e "${GREEN}Port: 7891${NC}"
echo -e "${GREEN}User: laravel${NC}"
echo -e "${GREEN}Password: secret${NC}"
echo -e "${GREEN}Database: laravel${NC}"
echo -e ""
echo -e "${YELLOW}To stop the environment, run:${NC}"
echo -e "${GREEN}docker-compose down${NC}"
echo -e ""
echo -e "${YELLOW}For Windows users:${NC}"
echo -e "${GREEN}Run the commands manually if this script doesn't work properly.${NC}"
echo -e "${GREEN}See README.md for more information.${NC}"
echo -e "${BLUE}========================================${NC}"

