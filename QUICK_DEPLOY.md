# Quick Start Guide - AWS Deployment
//k
## 🚀 5-Minute Deployment to AWS Amplify

### Prerequisites
- AWS Account
- GitHub Account
- OpenAI API Key

---

## Step 1: Push to GitHub (2 minutes)

```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Commit
git commit -m "Job RAG System - Ready for deployment"

# Create a new repository on GitHub, then:
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

---

## Step 2: Deploy to AWS Amplify (2 minutes)

1. **Go to AWS Amplify Console**
   - Visit: https://console.aws.amazon.com/amplify/
   - Sign in with your AWS account

2. **Create New App**
   - Click **"New app"** → **"Host web app"**
   - Select **"GitHub"** as your repository service
   - Click **"Continue"**

3. **Authorize GitHub**
   - Click **"Authorize AWS Amplify"**
   - Grant access to your repositories

4. **Select Repository**
   - Choose your repository from the list
   - Select branch: **main**
   - Click **"Next"**

5. **Configure Build**
   - App name: `job-rag-system` (or your choice)
   - The `amplify.yml` file will be auto-detected ✅
   - Click **"Next"**

6. **Review and Deploy**
   - Review settings
   - Click **"Save and deploy"**
   - Wait 1-2 minutes for deployment ⏱️

7. **Get Your URL**
   - Copy the Amplify URL (e.g., `https://main.d1a2b3c4.amplifyapp.com`)
   - Your frontend is now live! 🎉

---

## Step 3: Update API URL (1 minute)

### Current State:
Your frontend is deployed but pointing to `localhost:5000` which won't work.

### Options:

#### Option A: Keep Backend Local (For Testing)
If you want to test locally:
1. Run API locally: `python api.py`
2. Your deployed site won't work for others, only for local testing

#### Option B: Deploy Backend to AWS Lambda (Recommended)
Follow the detailed guide in `AWS_DEPLOYMENT_GUIDE.md` - Part 2

#### Option C: Deploy Backend to EC2 (Simpler)
1. **Launch EC2 instance** (t3.small, Ubuntu 22.04)
2. **SSH into instance**
3. **Setup application**:
   ```bash
   # Install dependencies
   sudo apt update
   sudo apt install python3-pip python3-venv nginx certbot python3-certbot-nginx -y
   
   # Clone your repo
   git clone YOUR_GITHUB_REPO_URL
   cd aws_rag
   
   # Setup Python environment
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   pip install gunicorn
   
   # Set your OpenAI API key
   export OPENAI_API_KEY='your-key-here'
   
   # Run the API
   gunicorn -w 4 -b 0.0.0.0:5000 api:app
   ```

4. **Get your EC2 public IP** (e.g., `54.123.45.67`)

5. **Update index.html**:
   Change line ~235:
   ```javascript
   const API_URL = 'http://YOUR_EC2_IP:5000';  // Use your EC2 IP
   ```

6. **Commit and push**:
   ```bash
   git add index.html
   git commit -m "Update API URL"
   git push
   ```
   
   Amplify will auto-deploy the update! ✅

---

## Step 4: Test Your App 🧪

1. Open your Amplify URL
2. Try searching: "data analyst jobs in Brisbane"
3. You should see results with AI insights!

---

## Troubleshooting

### ❌ "Failed to connect to server"
- Backend is not running or URL is wrong
- Check API_URL in index.html matches your backend
- If using EC2, ensure security group allows port 5000

### ❌ CORS Error
- Add CORS to your Flask API (already done in api.py)
- If using EC2 with domain, update CORS settings

### ❌ "Cannot read properties of undefined"
- Check browser console for specific errors
- Ensure backend is returning proper JSON

---

## Production Checklist

Before going to production:

- [ ] Backend deployed to cloud (not localhost)
- [ ] HTTPS enabled (use CloudFront or EC2 with SSL)
- [ ] Environment variables secured (AWS Secrets Manager)
- [ ] API rate limiting enabled
- [ ] Error monitoring setup (CloudWatch, Sentry)
- [ ] Backup strategy for embeddings
- [ ] Cost monitoring alerts configured

---

## Costs

### Free Tier (First 12 months):
- ✅ AWS Amplify: 1,000 build minutes/month FREE
- ✅ Lambda: 1M requests/month FREE
- ✅ EC2: 750 hours/month t2.micro FREE (t3.small costs ~$15/month)

### After Free Tier:
- Amplify: ~$1-2/month for low traffic
- Lambda + API Gateway: ~$3-5/month for low traffic
- EC2 t3.small: ~$15/month (24/7)
- S3 storage: <$1/month

**Total: $5-20/month** for a production-ready application

---

## What's Deployed?

### ✅ Frontend (Amplify):
- Static HTML/CSS/JavaScript
- Global CDN distribution
- HTTPS enabled by default
- Auto-deploys on git push

### 🔄 Backend (Choose one):
- **Option 1**: Local (for development only)
- **Option 2**: AWS Lambda (serverless, auto-scaling)
- **Option 3**: EC2 (traditional server)

---

## Next Steps

1. **Add Custom Domain**
   - In Amplify: Domain Management → Add domain
   - Follow AWS instructions for DNS setup

2. **Enable Authentication** (Optional)
   - Add AWS Cognito
   - Require login to search jobs

3. **Add Analytics** (Optional)
   - Enable Amplify Analytics
   - Track user searches and behavior

4. **Improve Performance**
   - Add CloudFront CDN
   - Cache API responses
   - Optimize embeddings loading

---

## Need Help?

- 📖 Full guide: `AWS_DEPLOYMENT_GUIDE.md`
- 🐛 Issues: Create GitHub issue
- 📧 AWS Support: https://aws.amazon.com/support/

**You're ready to deploy! 🚀**
