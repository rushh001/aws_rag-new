# 🚀 QUICK START GUIDE

Get your Job RAG system up and running in 5 minutes!

## Prerequisites Checklist

- [ ] Python 3.8+ installed
- [ ] Node.js 16+ installed  
- [ ] OpenAI API key ready
- [ ] Terminal/PowerShell access

## Setup Steps

### 1️⃣ Run Setup Script (2 minutes)

```powershell
.\setup.ps1
```

This will:
- Create Python virtual environment
- Install all dependencies (Python + Node.js)
- Create configuration files

### 2️⃣ Add Your OpenAI API Key (30 seconds)

Edit the `.env` file:

```powershell
notepad .env
```

Change this line:
```
OPENAI_API_KEY=your_openai_api_key_here
```

To your actual key:
```
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxx
```

Save and close.

**Don't have an API key?** Get one at: https://platform.openai.com/api-keys

### 3️⃣ Generate Embeddings (3-10 minutes)

```powershell
.\venv\Scripts\activate
python generate_embeddings.py
```

This processes your job dataset and creates searchable embeddings.

**Wait time**: ~3-10 minutes depending on dataset size

### 4️⃣ Start the System (30 seconds)

```powershell
.\run.ps1
```

This opens two new windows:
- Backend API (runs on port 5000)
- Frontend App (runs on port 3000)

Your browser should automatically open to `http://localhost:3000`

## 🎉 You're Done!

Try searching for:
- "data analyst jobs in Brisbane"
- "senior developer positions"
- "business analyst roles"

## Next Steps

### Deploy to AWS Amplify

1. Push code to GitHub:
   ```powershell
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/job-rag.git
   git push -u origin main
   ```

2. Go to [AWS Amplify Console](https://console.aws.amazon.com/amplify/)

3. Click "New app" → "Host web app"

4. Connect your GitHub repository

5. Deploy! ✨

See `DEPLOYMENT.md` for detailed instructions.

## Troubleshooting

### Issue: "Python not found"
**Solution**: Install Python from https://www.python.org/downloads/

### Issue: "Node not found"  
**Solution**: Install Node.js from https://nodejs.org/

### Issue: "OpenAI API error"
**Solution**: Check your API key in `.env` file

### Issue: "Port already in use"
**Solution**: 
```powershell
# Change port in .env
PORT=5001
```

### Issue: "Embeddings not found"
**Solution**:
```powershell
python generate_embeddings.py
```

## Manual Start (Alternative)

If `.\run.ps1` doesn't work:

**Terminal 1 - Backend:**
```powershell
.\venv\Scripts\activate
python api.py
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm start
```

## Useful Commands

```powershell
# Test system
python test_system.py

# View API health
Invoke-RestMethod http://localhost:5000/api/health

# Regenerate embeddings
python generate_embeddings.py

# Build frontend for production
cd frontend
npm run build
```

## File Structure (What Was Created)

```
aws_rag/
├── 📄 README.md              # Full documentation
├── 📄 QUICK_START.md         # This file
├── 📄 DEPLOYMENT.md          # AWS deployment guide
├── 🐍 generate_embeddings.py # Create embeddings
├── 🐍 rag_system.py          # RAG logic
├── 🐍 api.py                 # Backend API
├── ⚙️ .env                   # Your config (not in git)
├── 📁 embeddings/            # Generated embeddings
└── 📁 frontend/              # React app
    ├── 📦 package.json
    └── 📁 src/
        └── 📄 App.js         # Main UI
```

## Getting Help

1. **Check logs** - Look at the terminal windows for errors
2. **Run tests** - `python test_system.py`
3. **Read docs**:
   - `README.md` - Complete guide
   - `QUICK_REFERENCE.md` - Command reference
   - `DEPLOYMENT.md` - Deployment guide

## Cost Information

### Development (Free)
- OpenAI: ~$0.10 for embeddings generation
- Local: Free (runs on your computer)

### Production (per month)
- OpenAI API: $5-20
- AWS Amplify: $10-30
- Total: ~$15-50/month

## What's Happening Behind the Scenes?

1. **Your CSV** → Contains job listings
2. **Embeddings** → AI converts jobs to vectors
3. **FAISS** → Fast similarity search engine
4. **Your Query** → Converted to vector
5. **Search** → Finds similar job vectors
6. **GPT-4** → Generates insights
7. **Display** → Shows results in UI

## Example API Request

```powershell
$body = @{
    query = "data analyst Brisbane"
    top_k = 5
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/search" `
  -Method POST `
  -Body $body `
  -ContentType "application/json"
```

## Security Reminders

- ✅ Never commit `.env` file to git
- ✅ Keep your OpenAI API key secret
- ✅ Use environment variables in production
- ✅ Enable HTTPS in production

## Success Indicators

You'll know it's working when:

✅ Setup script completes without errors  
✅ Embeddings folder has 3 files (.npy, .bin, .pkl)  
✅ Backend shows "RAG system initialized"  
✅ Frontend opens in browser  
✅ Search returns job results with AI insights  

## Ready to Go!

Your AI-powered job search system is ready! 🎯

**Start searching** → Open http://localhost:3000

**Need help?** → Check README.md or QUICK_REFERENCE.md

**Want to deploy?** → See DEPLOYMENT.md

---

**Happy Job Hunting!** 🚀
