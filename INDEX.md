# 📚 Documentation Index

Welcome to the Job RAG System documentation! This index will help you find the information you need quickly.

## 🚀 Getting Started

### For First-Time Users
1. **[QUICK_START.md](QUICK_START.md)** ⭐ **START HERE**
   - 5-minute setup guide
   - Step-by-step instructions
   - Troubleshooting basics

### For Detailed Setup
2. **[README.md](README.md)** 📖 **Main Documentation**
   - Complete feature overview
   - Detailed setup instructions
   - API documentation
   - Usage examples

## 🎯 By User Type

### I want to...

#### Use the System Locally
→ Read: [QUICK_START.md](QUICK_START.md)
→ Run: `.\setup.ps1` then `.\run.ps1`

#### Deploy to Production
→ Read: [DEPLOYMENT.md](DEPLOYMENT.md)
→ Focus: AWS Amplify deployment section

#### Understand the Architecture
→ Read: [ARCHITECTURE.md](ARCHITECTURE.md)
→ See: Visual diagrams and data flows

#### Find Quick Commands
→ Read: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
→ Use: As a command cheat sheet

#### See What Was Built
→ Read: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
→ Get: Complete project overview

## 📁 File Descriptions

### Documentation Files

| File | Purpose | When to Read |
|------|---------|--------------|
| **QUICK_START.md** | Fast setup guide | First time setup |
| **README.md** | Complete documentation | Need full details |
| **DEPLOYMENT.md** | AWS deployment guide | Ready to deploy |
| **ARCHITECTURE.md** | System design & diagrams | Understanding how it works |
| **QUICK_REFERENCE.md** | Command reference | Daily development |
| **PROJECT_SUMMARY.md** | Project overview | Understanding what exists |
| **INDEX.md** | This file | Finding documentation |

### Code Files

| File | Purpose | Key Functions |
|------|---------|---------------|
| **generate_embeddings.py** | Create embeddings | `run_pipeline()` |
| **rag_system.py** | RAG query system | `query()`, `search_similar_jobs()` |
| **api.py** | Flask REST API | API endpoints |
| **test_system.py** | System verification | `main()` |

### Configuration Files

| File | Purpose | Edit When |
|------|---------|-----------|
| **.env** | Backend secrets | Adding API key |
| **frontend/.env** | Frontend config | Changing API URL |
| **requirements.txt** | Python packages | Adding dependencies |
| **frontend/package.json** | Node packages | Adding libraries |
| **amplify.yml** | AWS Amplify config | Deploying to AWS |

### Utility Scripts

| File | Purpose | Usage |
|------|---------|-------|
| **setup.ps1** | Automated setup | `.\setup.ps1` |
| **run.ps1** | Start system | `.\run.ps1` |

## 🎓 Learning Path

### Level 1: Complete Beginner
1. Read [QUICK_START.md](QUICK_START.md) (5 min)
2. Run `.\setup.ps1` (2 min)
3. Add API key to `.env` (1 min)
4. Run `python generate_embeddings.py` (5 min)
5. Run `.\run.ps1` (1 min)
6. Test the app at `http://localhost:3000`

**Time**: ~15 minutes

### Level 2: Understanding the System
1. Read [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) (10 min)
2. Read [ARCHITECTURE.md](ARCHITECTURE.md) (15 min)
3. Explore code files:
   - `generate_embeddings.py`
   - `rag_system.py`
   - `api.py`
4. Test API endpoints with PowerShell

**Time**: ~1 hour

### Level 3: Production Deployment
1. Read [DEPLOYMENT.md](DEPLOYMENT.md) (20 min)
2. Set up GitHub repository
3. Configure AWS Amplify
4. Deploy frontend
5. Deploy backend (Lambda/EC2)
6. Configure environment variables
7. Test production deployment

**Time**: ~2-3 hours

### Level 4: Customization
1. Modify frontend UI in `frontend/src/App.js`
2. Adjust RAG logic in `rag_system.py`
3. Add new API endpoints in `api.py`
4. Experiment with different OpenAI models
5. Optimize FAISS indexing

**Time**: Ongoing

## 🔍 Common Questions

### Setup Questions

**Q: How do I get an OpenAI API key?**
→ See: [QUICK_START.md](QUICK_START.md#2️⃣-add-your-openai-api-key)

**Q: What if setup.ps1 fails?**
→ See: [QUICK_START.md](QUICK_START.md#troubleshooting)

**Q: How long does embedding generation take?**
→ See: [README.md](README.md#step-3-generate-embeddings) (~3-10 minutes)

### Usage Questions

**Q: How do I search for jobs?**
→ See: [README.md](README.md#🔧-usage)

**Q: What can I search for?**
→ See: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md#📈-usage-examples)

**Q: How do I use the API directly?**
→ See: [README.md](README.md#api-endpoints)

### Deployment Questions

**Q: How do I deploy to AWS?**
→ See: [DEPLOYMENT.md](DEPLOYMENT.md)

**Q: What will it cost?**
→ See: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md#💰-cost-estimates)

**Q: Can I use a different cloud provider?**
→ See: [DEPLOYMENT.md](DEPLOYMENT.md) (adapt for your provider)

### Technical Questions

**Q: How does RAG work?**
→ See: [ARCHITECTURE.md](ARCHITECTURE.md#data-flow---query-process)

**Q: What are embeddings?**
→ See: [ARCHITECTURE.md](ARCHITECTURE.md#embedding-generation-process)

**Q: How fast is the search?**
→ See: [ARCHITECTURE.md](ARCHITECTURE.md#requestresponse-cycle-times)

## 🛠️ Development Guides

### Daily Development
**Use**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- Start/stop commands
- Testing commands
- Common operations

### Making Changes

#### Update Dataset
1. Replace CSV file
2. Run `python generate_embeddings.py`
3. Restart API

→ See: [QUICK_REFERENCE.md](QUICK_REFERENCE.md#update-dataset)

#### Update Frontend
1. Edit files in `frontend/src/`
2. Changes auto-reload
3. No restart needed

→ See: [README.md](README.md#🔧-usage)

#### Update Backend
1. Edit `api.py` or `rag_system.py`
2. Restart API (Ctrl+C, then `python api.py`)

→ See: [QUICK_REFERENCE.md](QUICK_REFERENCE.md#update-backend)

## 📊 Reference Materials

### API Endpoints
**Full Documentation**: [README.md](README.md#api-endpoints)

Quick Reference:
- `POST /api/search` - RAG query with AI
- `POST /api/similar-jobs` - Similarity search only
- `GET /api/health` - Health check
- `GET /api/stats` - System statistics

### File Locations
**Full Structure**: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md#📁-file-structure)

Quick Reference:
- Config: `.env` and `frontend/.env`
- Data: `seek_jobs (4).csv`
- Embeddings: `embeddings/` directory
- Frontend: `frontend/src/`

### Environment Variables
**Full List**: [README.md](README.md#⚙️-configuration)

Quick Reference:
```
Backend (.env):
- OPENAI_API_KEY
- PORT

Frontend (frontend/.env):
- REACT_APP_API_URL
```

## 🆘 Getting Help

### Error Messages

**"Module not found"**
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md#troubleshooting)

**"OpenAI API key not found"**
→ [QUICK_START.md](QUICK_START.md#2️⃣-add-your-openai-api-key)

**"Embeddings not loading"**
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md#embeddings-not-loading)

**"Port already in use"**
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md#port-already-in-use)

**"CORS error"**
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md#cors-error)

### Diagnostic Tools

**Run System Test**:
```powershell
python test_system.py
```

**Check API Health**:
```powershell
Invoke-RestMethod http://localhost:5000/api/health
```

**View Logs**:
- Backend: Check terminal running `api.py`
- Frontend: Check browser console (F12)

## 📈 Advanced Topics

### Performance Optimization
→ See: [README.md](README.md#📈-performance-optimization)

### Security Best Practices
→ See: [README.md](README.md#🔐-security-notes)
→ See: [DEPLOYMENT.md](DEPLOYMENT.md#security-best-practices)

### Scaling Considerations
→ See: [ARCHITECTURE.md](ARCHITECTURE.md)
→ See: [DEPLOYMENT.md](DEPLOYMENT.md#cost-estimation)

## 🔄 Update Guide

### When Dataset Changes
1. Run embedding generation
2. Restart system
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md#update-dataset)

### When Dependencies Change
1. Update `requirements.txt` or `package.json`
2. Reinstall dependencies
3. Restart services

### When Deploying Updates
1. Push to GitHub
2. Amplify auto-deploys frontend
3. Manually deploy backend
→ [DEPLOYMENT.md](DEPLOYMENT.md#updating-the-application)

## 📝 Quick Links

- **OpenAI Documentation**: https://platform.openai.com/docs
- **FAISS Documentation**: https://faiss.ai/
- **React Documentation**: https://react.dev/
- **Flask Documentation**: https://flask.palletsprojects.com/
- **AWS Amplify**: https://docs.amplify.aws/

## 🎯 Next Steps

Choose your path:

### I'm New Here
→ Start with [QUICK_START.md](QUICK_START.md)

### I'm Ready to Deploy
→ Read [DEPLOYMENT.md](DEPLOYMENT.md)

### I Want to Customize
→ Study [ARCHITECTURE.md](ARCHITECTURE.md) then modify code

### I Need Quick Help
→ Use [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

### I Want Full Details
→ Read [README.md](README.md)

---

## 📧 Support

If you can't find what you need:

1. Check the **Troubleshooting** sections in each guide
2. Run `python test_system.py` to diagnose issues
3. Review error logs in terminals
4. Check that all prerequisites are installed
5. Verify environment variables are set correctly

---

**Happy Building! 🚀**
