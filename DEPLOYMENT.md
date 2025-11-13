# AWS Amplify Deployment Guide

## Overview

This guide will help you deploy the Job RAG frontend to AWS Amplify. The backend API will need to be deployed separately (e.g., on AWS Lambda, EC2, or Elastic Beanstalk).

## Prerequisites

- AWS Account
- GitHub account (recommended) or AWS Amplify CLI
- Backend API deployed and accessible via HTTPS

## Deployment Options

### Option 1: Deploy via AWS Amplify Console (Recommended)

This is the easiest method for deploying the frontend.

#### Step 1: Prepare Your Repository

1. Create a new GitHub repository
2. Push your code:
   ```powershell
   git init
   git add .
   git commit -m "Initial commit - Job RAG System"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/job-rag.git
   git push -u origin main
   ```

#### Step 2: Connect to AWS Amplify

1. Go to [AWS Amplify Console](https://console.aws.amazon.com/amplify/)
2. Click "New app" → "Host web app"
3. Select "GitHub" as your repository service
4. Authorize AWS Amplify to access your GitHub account
5. Select your repository and branch (main)

#### Step 3: Configure Build Settings

AWS Amplify should auto-detect the `amplify.yml` file. Verify it looks like this:

```yaml
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - cd frontend
        - npm ci
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: frontend/build
    files:
      - '**/*'
  cache:
    paths:
      - frontend/node_modules/**/*
```

#### Step 4: Add Environment Variables

In the Amplify Console:
1. Go to "Environment variables" in the left menu
2. Add a new variable:
   - Key: `REACT_APP_API_URL`
   - Value: Your backend API URL (e.g., `https://your-api.com`)

#### Step 5: Deploy

1. Click "Save and deploy"
2. Wait for the build to complete (usually 2-5 minutes)
3. Your app will be available at `https://xxxxx.amplifyapp.com`

### Option 2: Deploy via Amplify CLI

#### Step 1: Install Amplify CLI

```powershell
npm install -g @aws-amplify/cli
```

#### Step 2: Configure Amplify

```powershell
amplify configure
```

Follow the prompts to:
- Sign in to AWS Console
- Create an IAM user
- Enter access keys

#### Step 3: Initialize Amplify

```powershell
cd frontend
amplify init
```

Configuration:
- Enter a name for the project: `job-rag-frontend`
- Enter a name for the environment: `prod`
- Choose your default editor
- Choose the type of app: `javascript`
- Framework: `react`
- Source Directory Path: `src`
- Distribution Directory Path: `build`
- Build Command: `npm run build`
- Start Command: `npm start`

#### Step 4: Add Hosting

```powershell
amplify add hosting
```

Choose:
- Hosting with Amplify Console (Managed hosting)
- Manual deployment

#### Step 5: Publish

```powershell
# Set environment variable
$env:REACT_APP_API_URL="https://your-api-url.com"

# Build and publish
amplify publish
```

## Backend Deployment Options

### Option A: AWS Lambda + API Gateway

Best for: Serverless, cost-effective solution

#### Step 1: Prepare Lambda Function

1. Create a `lambda_function.py`:
```python
from rag_system import JobRAGSystem
import json

rag_system = JobRAGSystem()

def lambda_handler(event, context):
    body = json.loads(event['body'])
    query = body.get('query')
    top_k = body.get('top_k', 5)
    
    result = rag_system.query(query, top_k)
    
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        },
        'body': json.dumps({'success': True, 'data': result})
    }
```

2. Package dependencies:
```powershell
pip install -t package/ -r requirements.txt
# Copy your code files
# Create deployment package
```

3. Upload to AWS Lambda with API Gateway

### Option B: AWS Elastic Beanstalk

Best for: Full Flask application deployment

#### Step 1: Install EB CLI

```powershell
pip install awsebcli
```

#### Step 2: Initialize EB

```powershell
eb init -p python-3.9 job-rag-api
```

#### Step 3: Create Environment

```powershell
eb create job-rag-prod
```

#### Step 4: Deploy

```powershell
eb deploy
```

#### Step 5: Set Environment Variables

```powershell
eb setenv OPENAI_API_KEY=your-key-here
```

### Option C: AWS EC2

Best for: Full control and custom configuration

1. Launch an EC2 instance (Ubuntu recommended)
2. Install Python and dependencies
3. Copy your code to the instance
4. Set up Nginx as reverse proxy
5. Use PM2 or systemd to keep the API running
6. Configure SSL with Let's Encrypt

## Post-Deployment

### Update Frontend API URL

After deploying the backend, update your Amplify environment variable:

1. Go to AWS Amplify Console
2. Select your app
3. Go to "Environment variables"
4. Update `REACT_APP_API_URL` with your backend URL
5. Trigger a new deployment

### Enable HTTPS

AWS Amplify automatically provides HTTPS for the frontend. Ensure your backend API also uses HTTPS.

### Set Up Custom Domain (Optional)

1. In Amplify Console, go to "Domain management"
2. Add your custom domain
3. Follow DNS configuration instructions
4. Wait for SSL certificate provisioning

## Monitoring and Maintenance

### AWS Amplify

- View build logs in the Amplify Console
- Monitor performance in AWS CloudWatch
- Set up notifications for deployment status

### Backend API

- Monitor Lambda/EC2 logs in CloudWatch
- Set up CloudWatch alarms for errors
- Monitor API Gateway metrics

## Cost Estimation

### AWS Amplify (Frontend)
- First 1 GB storage: Free
- Build minutes: First 1,000 minutes free per month
- Data transfer: First 15 GB free per month
- After free tier: ~$10-50/month for typical usage

### Backend (Lambda)
- First 1M requests free per month
- After free tier: ~$0.20 per 1M requests
- Embedding storage in S3: ~$0.023 per GB/month

### Total Estimated Cost
- Development/Testing: Free (within free tier)
- Production (low traffic): $10-30/month
- Production (high traffic): $50-200/month

## Troubleshooting

### Build Fails on Amplify

Check:
- `amplify.yml` configuration
- Node version compatibility
- Dependencies in `package.json`

### CORS Errors

Ensure backend API has proper CORS headers:
```python
from flask_cors import CORS
CORS(app, origins=['https://your-amplify-app.amplifyapp.com'])
```

### Environment Variables Not Working

- Clear build cache in Amplify Console
- Trigger new deployment
- Check variable names (must start with `REACT_APP_`)

## Security Best Practices

1. **API Keys**: Never commit API keys to Git
2. **CORS**: Restrict CORS to your Amplify domain
3. **Rate Limiting**: Implement rate limiting on your API
4. **Authentication**: Consider adding user authentication
5. **HTTPS**: Always use HTTPS for API and frontend

## Updating the Application

### Update Frontend

```powershell
git add .
git commit -m "Update frontend"
git push origin main
# Amplify auto-deploys on push
```

### Update Backend

**Lambda**:
```powershell
# Update and redeploy Lambda function
aws lambda update-function-code --function-name job-rag-api --zip-file fileb://deployment.zip
```

**Elastic Beanstalk**:
```powershell
eb deploy
```

## Additional Resources

- [AWS Amplify Documentation](https://docs.amplify.aws/)
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [AWS Elastic Beanstalk Documentation](https://docs.aws.amazon.com/elasticbeanstalk/)
- [Flask Deployment on AWS](https://flask.palletsprojects.com/en/2.3.x/deploying/)

## Support

For deployment issues:
1. Check AWS CloudWatch logs
2. Review Amplify build logs
3. Test API endpoints directly
4. Verify environment variables

---

**Good luck with your deployment! 🚀**
