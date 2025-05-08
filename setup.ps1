# =======================================================
# Laravel Docker Environment Setup Script for Windows
# =======================================================
# This PowerShell script sets up the Docker-based Laravel 
# environment on Windows with proper configuration.
# =======================================================

# Colors for better readability
$Green = [System.ConsoleColor]::Green
$Blue = [System.ConsoleColor]::Cyan
$Red = [System.ConsoleColor]::Red
$Yellow = [System.ConsoleColor]::Yellow

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Separator {
    Write-ColorOutput $Blue "========================================================"
}

# Display header
Write-Separator
Write-ColorOutput $Green "Laravel Docker Environment Setup for Windows"
Write-Separator

# Check if Docker is installed
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-ColorOutput $Red "Error: Docker is not installed. Please install Docker Desktop for Windows first."
    exit 1
}

# Check if Docker is running
try {
    $null = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput $Red "Error: Docker is not running. Please start Docker Desktop."
        exit 1
    }
}
catch {
    Write-ColorOutput $Red "Error: Docker is not running. Please start Docker Desktop."
    exit 1
}

# Step 1: Create required directories
Write-ColorOutput $Green "Step 1: Creating required directories..."
$directories = @(
    "src\storage\app\public",
    "src\storage\framework\cache",
    "src\storage\framework\sessions",
    "src\storage\framework\testing",
    "src\storage\framework\views",
    "src\bootstrap\cache"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Write-Output "Created directory: $dir"
    }
}

# Step 2: Check Laravel installation
Write-ColorOutput $Green "Step 2: Checking if Laravel is already installed..."
$needFreshInstall = $false
if (-not (Test-Path "src\vendor")) {
    Write-ColorOutput $Yellow "Laravel not detected. Will perform fresh installation."
    $needFreshInstall = $true
}
else {
    Write-ColorOutput $Yellow "Laravel seems to be already installed. Skipping installation."
}

# Step 3: Start Docker containers
Write-ColorOutput $Green "Step 3: Starting Docker containers..."
docker-compose up -d

# Step 4: Wait for containers to be ready
Write-ColorOutput $Yellow "Waiting for containers to be ready..."
Start-Sleep -Seconds 10

# Step 5: Setup based on installation status
if ($needFreshInstall) {
    # Fresh installation steps
    Write-ColorOutput $Green "Step 4: Installing Laravel dependencies..."
    docker-compose exec app composer install --no-interaction --no-progress

    Write-ColorOutput $Green "Step 5: Setting up .env file..."
    docker-compose exec app cp -n .env.example .env
    
    Write-ColorOutput $Green "Step 6: Generating application key..."
    docker-compose exec app php artisan key:generate

    Write-ColorOutput $Green "Step 7: Setting up database..."
    docker-compose exec app php artisan migrate --force
    
    Write-ColorOutput $Green "Step 8: Optimizing application..."
    docker-compose exec app php artisan optimize
}
else {
    # Refresh existing installation
    Write-ColorOutput $Green "Step 4: Refreshing configuration..."
    docker-compose exec app php artisan optimize
}

# Step 6: Set proper permissions
Write-ColorOutput $Green "Step 5: Setting proper permissions..."
docker-compose exec -u root app chown -R www-data:www-data /var/www/html/storage
docker-compose exec -u root app chown -R www-data:www-data /var/www/html/bootstrap/cache
docker-compose exec -u root app chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Display success message
Write-Separator
Write-ColorOutput $Green "Setup completed successfully!"
Write-Separator
Write-ColorOutput $Yellow "Your Laravel application is now running at:"
Write-Output "http://localhost:7890"
Write-Output ""
Write-ColorOutput $Yellow "MySQL database is available at:"
Write-Output "Host: localhost"
Write-Output "Port: 7891"
Write-Output "User: laravel"
Write-Output "Password: secret"
Write-Output "Database: laravel"
Write-Output ""
Write-ColorOutput $Yellow "To stop the environment, run:"
Write-Output "docker-compose down"
Write-Separator

