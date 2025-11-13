# Run Job RAG System
# This script starts both backend and frontend

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Job RAG System" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if embeddings exist
if (!(Test-Path "embeddings\embeddings.npy")) {
    Write-Host "⚠ Embeddings not found!" -ForegroundColor Yellow
    Write-Host ""
    $generate = Read-Host "Would you like to generate embeddings now? (y/n)"
    
    if ($generate -eq "y") {
        Write-Host "Generating embeddings (this may take a while)..." -ForegroundColor Yellow
        .\venv\Scripts\activate
        python generate_embeddings.py
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Failed to generate embeddings" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "❌ Cannot run system without embeddings" -ForegroundColor Red
        Write-Host "Run: python generate_embeddings.py" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "✓ Embeddings found" -ForegroundColor Green
Write-Host ""

# Start backend in new window
Write-Host "Starting backend API..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD'; .\venv\Scripts\activate; python api.py"

# Wait a moment for backend to start
Start-Sleep -Seconds 3

# Start frontend in new window
Write-Host "Starting frontend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\frontend'; npm start"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "System Started Successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Backend API: http://localhost:5000" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Two new PowerShell windows have opened." -ForegroundColor Yellow
Write-Host "Close those windows to stop the services." -ForegroundColor Yellow
Write-Host ""
