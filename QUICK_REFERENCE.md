# Quick Reference Guide

## Common Commands

### Initial Setup

```powershell
# Run setup script
.\setup.ps1

# Or manually:
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
cd frontend
npm install
cd ..
```

### Generate Embeddings

```powershell
# First time or when dataset changes
python generate_embeddings.py

# This creates:
# - embeddings/embeddings.npy
# - embeddings/faiss_index.bin
# - embeddings/metadata.pkl
```

### Run Backend

```powershell
# Activate virtual environment
.\venv\Scripts\activate

# Start API server
python api.py

# API runs on http://localhost:5000
```

### Run Frontend

```powershell
# In a new terminal
cd frontend
npm start

# App opens at http://localhost:3000
```

### Test API Endpoints

```powershell
# Health check
Invoke-RestMethod -Uri "http://localhost:5000/api/health"

# Search jobs
$body = @{
    query = "data analyst Brisbane"
    top_k = 5
} | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:5000/api/search" -Method POST -Body $body -ContentType "application/json"

# Get system stats
Invoke-RestMethod -Uri "http://localhost:5000/api/stats"
```

### Test RAG System Directly

```powershell
# Run test queries
python rag_system.py
```

## Development Workflow

### Update Dataset

```powershell
# 1. Replace CSV file with new data
# 2. Regenerate embeddings
python generate_embeddings.py

# 3. Restart API
# Stop current API (Ctrl+C)
python api.py
```

### Update Frontend

```powershell
cd frontend

# Make changes to src/App.js or other files

# No restart needed - hot reload is automatic
```

### Update Backend

```powershell
# Make changes to api.py or rag_system.py

# Restart the API
# Stop current API (Ctrl+C)
python api.py
```

## File Locations

### Configuration
- `.env` - Backend environment variables (API keys)
- `frontend/.env` - Frontend environment variables (API URL)

### Data
- `seek_jobs (4).csv` - Source dataset
- `embeddings/` - Generated embeddings and index

### Code
- `generate_embeddings.py` - Embedding generation
- `rag_system.py` - RAG query logic
- `api.py` - Flask REST API
- `frontend/src/App.js` - React frontend

## Useful Environment Variables

### Backend (.env)
```
OPENAI_API_KEY=sk-your-key-here
PORT=5000
```

### Frontend (frontend/.env)
```
REACT_APP_API_URL=http://localhost:5000
```

For production:
```
REACT_APP_API_URL=https://your-api-domain.com
```

## Troubleshooting

### "OpenAI API key not found"
```powershell
# Check .env file exists and has correct format
cat .env

# Should contain:
# OPENAI_API_KEY=sk-...
```

### "Module not found"
```powershell
# Reinstall Python dependencies
.\venv\Scripts\activate
pip install -r requirements.txt --force-reinstall

# Reinstall Node dependencies
cd frontend
rm -r node_modules
npm install
```

### "Port already in use"
```powershell
# Find and kill process on port 5000
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Or change port in .env
PORT=5001
```

### "CORS error"
```powershell
# Check Flask-CORS is installed
pip install flask-cors

# Check API URL in frontend/.env
cat frontend\.env
```

### "Embeddings not loading"
```powershell
# Check embeddings directory exists
ls embeddings

# If missing, regenerate
python generate_embeddings.py
```

## Git Commands

### Initial Commit
```powershell
git init
git add .
git commit -m "Initial commit - Job RAG System"
```

### Create GitHub Repository
```powershell
# Create repo on GitHub, then:
git remote add origin https://github.com/yourusername/job-rag.git
git branch -M main
git push -u origin main
```

### Update Repository
```powershell
git add .
git commit -m "Update: describe your changes"
git push
```

## AWS Amplify Commands

### Using Amplify CLI
```powershell
# Install CLI
npm install -g @aws-amplify/cli

# Configure
amplify configure

# Initialize in project
cd frontend
amplify init

# Add hosting
amplify add hosting

# Publish
amplify publish

# View status
amplify status

# Check console
amplify console
```

## Performance Tips

### Optimize Embeddings Generation
- Process in batches (default: 100)
- Adjust in `generate_embeddings.py`:
```python
generator.generate_embeddings(batch_size=50)
```

### Reduce API Response Time
- Reduce `top_k` value (fewer results)
- Use `similar-jobs` endpoint (skips AI response)

### Frontend Performance
```powershell
# Production build
cd frontend
npm run build

# Serve production build
npm install -g serve
serve -s build
```

## Monitoring

### Check API Logs
```powershell
# API prints to console
python api.py

# Watch for errors
```

### Check Frontend Logs
```powershell
# Open browser console (F12)
# Check for errors in Console tab
```

### Monitor OpenAI Usage
- Visit [OpenAI Dashboard](https://platform.openai.com/usage)
- Check API usage and costs

## Quick Testing

### Test Single Query
```python
# In Python REPL
from rag_system import JobRAGSystem
rag = JobRAGSystem()
result = rag.query("data analyst jobs", top_k=3)
print(result['ai_response'])
```

### Test API Endpoint
```powershell
# Using curl (if available)
curl -X POST http://localhost:5000/api/search `
  -H "Content-Type: application/json" `
  -d '{"query":"developer jobs","top_k":3}'
```

## Cleanup

### Remove Generated Files
```powershell
# Remove embeddings
rm -r embeddings

# Remove Python cache
rm -r __pycache__

# Remove frontend build
rm -r frontend/build
```

### Deactivate Virtual Environment
```powershell
deactivate
```

## Emergency Recovery

### Complete Reset
```powershell
# 1. Remove all generated files
rm -r embeddings, __pycache__, venv, frontend/node_modules

# 2. Re-run setup
.\setup.ps1

# 3. Regenerate embeddings
python generate_embeddings.py

# 4. Start services
python api.py  # Terminal 1
cd frontend && npm start  # Terminal 2
```

---

## Need Help?

- Check README.md for detailed documentation
- Check DEPLOYMENT.md for AWS deployment
- Check logs for error messages
- Ensure all environment variables are set correctly
