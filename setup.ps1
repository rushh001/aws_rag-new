# Quick Setup Script for Job RAG System
# Run this in PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Job RAG System - Quick Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Python
Write-Host "Checking Python installation..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Python found: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Python not found. Please install Python 3.8+" -ForegroundColor Red
    exit 1
}

# Check Node.js
Write-Host "Checking Node.js installation..." -ForegroundColor Yellow
$nodeVersion = node --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Node.js not found. Please install Node.js 16+" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 1: Setting up Python Environment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Create virtual environment
if (!(Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
    Write-Host "✓ Virtual environment created" -ForegroundColor Green
} else {
    Write-Host "✓ Virtual environment already exists" -ForegroundColor Green
}

# Activate and install dependencies
Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
.\venv\Scripts\activate
pip install -r requirements.txt
Write-Host "✓ Python dependencies installed" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 2: Environment Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check for .env file
if (!(Test-Path ".env")) {
    Write-Host "Creating .env file..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "⚠ Please edit .env and add your OpenAI API key!" -ForegroundColor Yellow
    Write-Host "  OPENAI_API_KEY=sk-your-api-key-here" -ForegroundColor Yellow
    
    $continue = Read-Host "Press Enter after adding your API key, or 'skip' to continue without it"
    if ($continue -eq "skip") {
        Write-Host "⚠ Skipping API key setup. You'll need to add it later." -ForegroundColor Yellow
    }
} else {
    Write-Host "✓ .env file already exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 3: Frontend Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Setup frontend
if (!(Test-Path "frontend/node_modules")) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    Set-Location frontend
    npm install
    Set-Location ..
    Write-Host "✓ Frontend dependencies installed" -ForegroundColor Green
} else {
    Write-Host "✓ Frontend dependencies already installed" -ForegroundColor Green
}

# Create frontend .env if it doesn't exist
if (!(Test-Path "frontend/.env")) {
    Write-Host "Creating frontend .env file..." -ForegroundColor Yellow
    "REACT_APP_API_URL=http://localhost:5000" | Out-File -FilePath "frontend\.env" -Encoding UTF8
    Write-Host "✓ Frontend .env created" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Generate embeddings: python generate_embeddings.py" -ForegroundColor White
Write-Host "2. Start backend API: python api.py" -ForegroundColor White
Write-Host "3. Start frontend (new terminal): cd frontend && npm start" -ForegroundColor White
Write-Host ""
Write-Host "See README.md for detailed instructions." -ForegroundColor Yellow
Write-Host ""
