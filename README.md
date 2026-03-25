# Job Search RAG System 🔍

An AI-powered job search application using **Retrieval-Augmented Generation (RAG)** with OpenAI embeddings, FAISS vector search, and a clean HTML/JavaScript frontend.

## 🌟 Features

- **Semantic Search**: Find jobs using natural language queries
- **AI-Powered Insights**: Get personalized recommendations from GPT-4
- **Local Embeddings Storage**: All embeddings stored locally for fast access
- **Modern UI**: Beautiful, responsive React interface
- **Fast Vector Search**: FAISS-powered similarity search
- **AWS Amplify Ready**: Easy deployment to AWS Amplify

## 📁 Project Structure

```
aws_rag/
├── generate_embeddings.py   # Generate and store embeddings
├── rag_system.py            # RAG query system
├── api.py                   # Flask REST API
├── index.html              # Frontend interface (HTML/CSS/JS)
├── requirements.txt         # Python dependencies
├── .env.example            # Environment variables template
├── seek_jobs (4).csv       # Your job dataset
├── embeddings/             # Local embedding storage (generated)
│   ├── embeddings.npy
│   ├── faiss_index.bin
│   └── metadata.pkl
├── amplify.yml            # AWS Amplify config
├── AWS_DEPLOYMENT_GUIDE.md  # Detailed AWS deployment guide
└── QUICK_DEPLOY.md         # Quick deployment steps
```

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- OpenAI API Key
- Modern web browser

### Step 1: Set Up Python Environment

```powershell
# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Step 2: Configure Environment Variables

```powershell
# Copy environment template
cp .env.example .env

# Edit .env and add your OpenAI API key
# OPENAI_API_KEY=sk-your-api-key-here
```

### Step 3: Generate Embeddings

This step creates embeddings for all jobs in your dataset and stores them locally.

```powershell
python generate_embeddings.py
```

**Note**: This will take some time depending on the dataset size. It processes jobs in batches and stores embeddings in the `embeddings/` directory.

### Step 4: Start the Backend API

```powershell
python api.py
```

The API will run on `http://localhost:5000`

### Step 5: Open the Frontend

Simply open `index.html` in your web browser, or use:

```powershell
# Windows
start index.html

# Or use a local server (optional)
python -m http.server 8000
# Then open http://localhost:8000
```

The app is now running! 🎉

## 🔧 Usage

### Using the Web Interface

1. Open `http://localhost:3000`
2. Enter a job search query (e.g., "data analyst positions in Brisbane")
3. Select the number of results you want (3, 5, or 10)
4. Click "Search Jobs"
5. View AI insights and matching job listings

### API Endpoints

#### Search Jobs with AI Response
```bash
POST http://localhost:5000/api/search
Content-Type: application/json

{
  "query": "Show me senior developer roles",
  "top_k": 5
}
```

#### Get Similar Jobs (No AI Response)
```bash
POST http://localhost:5000/api/similar-jobs
Content-Type: application/json

{
  "query": "business analyst",
  "top_k": 5
}
```

#### Health Check
```bash
GET http://localhost:5000/api/health
```

#### System Statistics
```bash
GET http://localhost:5000/api/stats
```

## 🌐 Deploying to AWS Amplify

### Quick Deploy (5 minutes) ⚡

See **[QUICK_DEPLOY.md](QUICK_DEPLOY.md)** for step-by-step deployment instructions.

### Full Deployment Guide 📚

See **[AWS_DEPLOYMENT_GUIDE.md](AWS_DEPLOYMENT_GUIDE.md)** for comprehensive deployment options including:
- AWS Amplify (Frontend)
- AWS Lambda + API Gateway (Backend)
- EC2 Alternative (Simpler backend option)
- Cost estimates and monitoring

### Quick Steps:

1. **Push to GitHub**:
   ```powershell
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/job-rag.git
   git push -u origin main
   ```

2. **Deploy on AWS Amplify**:
   - Go to [AWS Amplify Console](https://console.aws.amazon.com/amplify/)
   - Click "New app" → "Host web app"
   - Connect your GitHub repository
   - AWS Amplify will automatically detect the `amplify.yml` configuration
   - Deploy!

3. **Update API URL**:
   - After deploying backend, update `API_URL` in `index.html` (line ~235)
   - Commit and push - Amplify auto-deploys!

## ⚙️ Configuration

### Backend Configuration

Edit `.env`:
```
OPENAI_API_KEY=your-api-key-here
PORT=5000
```

### Frontend Configuration

Edit `index.html` (line ~235) and update the API URL:
```javascript
const API_URL = 'http://localhost:5000';  // For local development
// const API_URL = 'https://your-api-url.com';  // For production
```

## 🧪 Testing the System

### Test Backend Locally

```powershell
# Test with example queries
python rag_system.py
```

### Test API with curl (PowerShell)

```powershell
# Health check
Invoke-RestMethod -Uri "http://localhost:5000/api/health" -Method GET

# Search jobs
$body = @{
    query = "data analyst jobs"
    top_k = 3
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/search" -Method POST -Body $body -ContentType "application/json"
```

## 📊 How It Works

1. **Embedding Generation**: 
   - Combines job information (title, company, description, etc.)
   - Generates embeddings using OpenAI's `text-embedding-3-small` model
   - Stores embeddings locally using NumPy and FAISS

2. **RAG Query Process**:
   - User enters a natural language query
   - Query is embedded using the same model
   - FAISS performs fast similarity search
   - Top matching jobs are retrieved
   - GPT-4 generates insights based on the retrieved jobs

3. **Frontend Display**:
   - Shows AI-generated insights
   - Displays matching jobs with similarity scores
   - Provides direct links to job postings

## 🔐 Security Notes

- Never commit your `.env` file with API keys
- Use environment variables for production deployments
- Consider rate limiting for production APIs
- Store embeddings securely if they contain sensitive data

## 📈 Performance Optimization

- **Batch Processing**: Embeddings are generated in batches to optimize API usage
- **FAISS Index**: Fast similarity search even with large datasets
- **Local Storage**: Embeddings stored locally to avoid regeneration
- **Caching**: Consider adding Redis for API response caching

## 🐛 Troubleshooting

### "Module not found" errors
```powershell
pip install -r requirements.txt --force-reinstall
```

### Port already in use
```powershell
# Change port in api.py or .env
PORT=5001
```

### CORS errors
- Ensure Flask-CORS is installed
- Check API URL in frontend `.env`

### Embeddings not loading
```powershell
# Regenerate embeddings
python generate_embeddings.py
```

## 🔄 Updating the Dataset

When you have new job data:

```powershell
# 1. Replace the CSV file
# 2. Regenerate embeddings
python generate_embeddings.py

# 3. Restart the API
python api.py
```

## 📝 API Response Format

```json
{
  "success": true,
  "data": {
    "query": "data analyst jobs",
    "ai_response": "Based on the job listings...",
    "jobs": [
      {
        "job_id": "84129582",
        "job_title": "Senior Data Analyst",
        "company_name": "WSP Australia",
        "location": "Brisbane QLD",
        "salary": "NA",
        "job_url": "https://...",
        "similarity_score": 0.89,
        ...
      }
    ],
    "total_jobs_found": 5
  }
}
```

## 🤝 Contributing

Feel free to submit issues and enhancement requests!


## 🙏 Acknowledgments

- OpenAI for embeddings and GPT models
- FAISS for vector similarity search
- React team for the amazing frontend framework
- AWS Amplify for easy deployment
.

---

**Happy Job Hunting! 🎯**
