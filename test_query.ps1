# Simple Job Search Tester
# Run this to test your RAG system with custom queries

param(
    [string]$Query = "data analyst jobs in Brisbane"
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Job Search RAG - Quick Test" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Testing query: $Query`n" -ForegroundColor Yellow

try {
    $body = @{
        query = $Query
        top_k = 3
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri "http://localhost:5000/api/search" -Method POST -Body $body -ContentType "application/json"
    
    if ($result.success) {
        Write-Host "=== 💡 AI INSIGHTS ===" -ForegroundColor Green
        Write-Host $result.data.ai_response -ForegroundColor White
        
        Write-Host "`n=== 📋 TOP $($result.data.total_jobs_found) JOBS ===" -ForegroundColor Cyan
        $num = 1
        foreach($job in $result.data.jobs) {
            Write-Host "`n[$num] $($job.job_title)" -ForegroundColor Yellow
            Write-Host "    Company:  $($job.company_name)"
            Write-Host "    Location: $($job.location)"
            Write-Host "    Salary:   $($job.salary)"
            Write-Host "    Type:     $($job.job_type)"
            Write-Host "    Match:    $([math]::Round($job.similarity_score * 100))%" -ForegroundColor Green
            Write-Host "    URL:      $($job.job_url)" -ForegroundColor Cyan
            $num++
        }
        
        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host "✅ Test successful!`n" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure the API is running: python api.py`n" -ForegroundColor Yellow
}
