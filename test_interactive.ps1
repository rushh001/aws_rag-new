# Interactive Job Search RAG Tester
# This script lets you test the RAG system with your own queries

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "   Job Search RAG - Interactive Test   " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Check if API is running
try {
    $health = Invoke-RestMethod -Uri "http://localhost:5000/api/health" -ErrorAction Stop
    Write-Host "✓ API is running: $($health.message)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ API is not running!" -ForegroundColor Red
    Write-Host "Please start the API first with: python api.py" -ForegroundColor Yellow
    exit 1
}

# Interactive loop
while ($true) {
    Write-Host "Enter your job search query (or 'quit' to exit):" -ForegroundColor Yellow
    Write-Host "Examples:" -ForegroundColor Gray
    Write-Host "  - Show me data analyst jobs in Brisbane" -ForegroundColor Gray
    Write-Host "  - Senior developer positions with good salary" -ForegroundColor Gray
    Write-Host "  - Business analyst roles in government" -ForegroundColor Gray
    Write-Host ""
    
    $query = Read-Host "Your query"
    
    if ($query -eq "quit" -or $query -eq "exit" -or $query -eq "q") {
        Write-Host ""
        Write-Host "Thanks for using Job Search RAG! Goodbye! 👋" -ForegroundColor Cyan
        break
    }
    
    if ([string]::IsNullOrWhiteSpace($query)) {
        Write-Host "Please enter a valid query." -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    Write-Host ""
    Write-Host "Searching..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        # Make API request
        $body = @{
            query = $query
            top_k = 3
        } | ConvertTo-Json
        
        $result = Invoke-RestMethod -Uri "http://localhost:5000/api/search" `
            -Method POST `
            -Body $body `
            -ContentType "application/json"
        
        if ($result.success) {
            # Display AI Response
            Write-Host "=======================================" -ForegroundColor Green
            Write-Host "💡 AI INSIGHTS" -ForegroundColor Green
            Write-Host "=======================================" -ForegroundColor Green
            Write-Host $result.data.ai_response -ForegroundColor White
            Write-Host ""
            
            # Display Jobs
            Write-Host "=======================================" -ForegroundColor Cyan
            Write-Host "📋 MATCHING JOBS ($($result.data.total_jobs_found) found)" -ForegroundColor Cyan
            Write-Host "=======================================" -ForegroundColor Cyan
            Write-Host ""
            
            $jobNum = 1
            foreach ($job in $result.data.jobs) {
                Write-Host "Job $jobNum" -ForegroundColor Yellow
                Write-Host "  Title:      $($job.job_title)" -ForegroundColor White
                Write-Host "  Company:    $($job.company_name)" -ForegroundColor White
                Write-Host "  Location:   $($job.location)" -ForegroundColor White
                Write-Host "  Salary:     $($job.salary)" -ForegroundColor White
                Write-Host "  Type:       $($job.job_type)" -ForegroundColor White
                Write-Host "  Match:      $([math]::Round($job.similarity_score * 100, 1))%" -ForegroundColor Green
                Write-Host "  URL:        $($job.job_url)" -ForegroundColor Cyan
                Write-Host ""
                $jobNum++
            }
        } else {
            Write-Host "Error: Failed to get results" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
    }
    
    Write-Host "=======================================" -ForegroundColor Gray
    Write-Host ""
}
