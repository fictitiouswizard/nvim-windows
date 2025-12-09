# Neovim Development Environment Setup Script
# Run this in PowerShell as Administrator for best results

Write-Host "=== Neovim Development Environment Setup ===" -ForegroundColor Cyan
Write-Host ""

# Function to check if a command exists
function Test-Command {
    param($Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "WARNING: Not running as Administrator. Some installations may fail." -ForegroundColor Yellow
    Write-Host "Consider running: Right-click PowerShell -> Run as Administrator" -ForegroundColor Yellow
    Write-Host ""
}

# Install Node.js
Write-Host "Checking Node.js..." -ForegroundColor Green
if (Test-Command node) {
    $nodeVersion = node --version
    Write-Host "  Node.js already installed: $nodeVersion" -ForegroundColor Gray
} else {
    Write-Host "  Installing Node.js..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Node.js installed successfully" -ForegroundColor Green
    } else {
        Write-Host "  Failed to install Node.js" -ForegroundColor Red
    }
}

# Install Python
Write-Host "Checking Python..." -ForegroundColor Green
if (Test-Command python) {
    $pythonVersion = python --version
    Write-Host "  Python already installed: $pythonVersion" -ForegroundColor Gray
} else {
    Write-Host "  Installing Python..." -ForegroundColor Yellow
    winget install Python.Python.3.12 --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Python installed successfully" -ForegroundColor Green
    } else {
        Write-Host "  Failed to install Python" -ForegroundColor Red
    }
}

# Refresh environment variables
Write-Host ""
Write-Host "Refreshing PATH..." -ForegroundColor Green
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Create Python virtual environment for Neovim
Write-Host ""
Write-Host "Setting up Python LSP virtual environment..." -ForegroundColor Green
$venvPath = "$env:LOCALAPPDATA\nvim-venv"

if (Test-Path $venvPath) {
    Write-Host "  Virtual environment already exists at: $venvPath" -ForegroundColor Gray
} else {
    Write-Host "  Creating virtual environment at: $venvPath" -ForegroundColor Yellow
    python -m venv $venvPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Virtual environment created successfully" -ForegroundColor Green
    } else {
        Write-Host "  Failed to create virtual environment" -ForegroundColor Red
        exit 1
    }
}

# Install Python LSP packages
Write-Host "  Installing Python LSP packages..." -ForegroundColor Yellow
& "$venvPath\Scripts\python.exe" -m pip install --upgrade pip --quiet
& "$venvPath\Scripts\pip.exe" install ruff --quiet
& "$venvPath\Scripts\pip.exe" install python-lsp-server python-lsp-ruff --quiet

if ($LASTEXITCODE -eq 0) {
    Write-Host "  Python LSP packages installed" -ForegroundColor Green
} else {
    Write-Host "  Failed to install Python LSP packages" -ForegroundColor Red
}

# Install additional recommended tools
Write-Host ""
Write-Host "Installing additional development tools..." -ForegroundColor Green

# Ripgrep
if (Test-Command rg) {
    Write-Host "  ripgrep already installed" -ForegroundColor Gray
} else {
    Write-Host "  Installing ripgrep..." -ForegroundColor Yellow
    winget install BurntSushi.ripgrep.MSVC --silent
}

# fd
if (Test-Command fd) {
    Write-Host "  fd already installed" -ForegroundColor Gray
} else {
    Write-Host "  Installing fd..." -ForegroundColor Yellow
    winget install sharkdp.fd --silent
}

# Git
if (Test-Command git) {
    Write-Host "  Git already installed" -ForegroundColor Gray
} else {
    Write-Host "  Installing Git..." -ForegroundColor Yellow
    winget install Git.Git --silent
}

# Make
if (Test-Command make) {
    Write-Host "  make already installed" -ForegroundColor Gray
} else {
    Write-Host "  Installing make..." -ForegroundColor Yellow
    winget install GnuWin32.Make --silent
}

# Summary
Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Close this terminal and open a new one for PATH changes to take effect!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Installed components:" -ForegroundColor Cyan
Write-Host "  - Node.js (for JavaScript/TypeScript LSP)" -ForegroundColor White
Write-Host "  - Python (for Python development)" -ForegroundColor White
Write-Host "  - Python LSP server at: $venvPath" -ForegroundColor White
Write-Host "  - ripgrep (for Telescope search)" -ForegroundColor White
Write-Host "  - fd (for Telescope file finding)" -ForegroundColor White
Write-Host "  - Git (for version control)" -ForegroundColor White
Write-Host "  - make (for building plugins)" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Close this terminal" -ForegroundColor White
Write-Host "  2. Open a new terminal" -ForegroundColor White
Write-Host "  3. Run: nvim" -ForegroundColor White
Write-Host "  4. Wait for plugins to install" -ForegroundColor White
Write-Host "  5. Run :checkhealth to verify everything works" -ForegroundColor White
Write-Host ""
