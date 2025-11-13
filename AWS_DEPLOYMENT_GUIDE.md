# AWS Deployment Guide for Job RAG System

This guide will help you deploy your Job Search RAG system to AWS using:
- **AWS Amplify** for the frontend (HTML/JavaScript)
- **AWS Lambda + API Gateway** for the backend (Python Flask API)
- **Amazon S3** for storing embeddings

---

## Architecture Overview

```
User Browser (index.html)
    ↓
AWS Amplify (Static HTML Hosting)
    ↓
API Gateway
    ↓
AWS Lambda (Flask API)
    ↓
S3 Bucket (Embeddings & Metadata)
    ↓
OpenAI API (Embeddings & GPT)
```

---

## Part 1: Deploy Frontend to AWS Amplify

### Option A: Deploy via GitHub (Recommended)

1. **Push your code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit - Job RAG System"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

2. **Connect to AWS Amplify**
   - Go to [AWS Amplify Console](https://console.aws.amazon.com/amplify/)
   - Click **"New app"** → **"Host web app"**
   - Select **GitHub** as source
   - Authorize AWS Amplify to access your repositories
   - Select your repository and branch (main)

3. **Configure Build Settings**
   - Amplify will auto-detect the `amplify.yml` file
   - The current config is set for static HTML hosting
   - Click **"Next"** then **"Save and deploy"**

4. **Update API URL in index.html**
   - After deploying the backend (Part 2), update the API_URL in index.html:
   ```javascript
   const API_URL = 'https://YOUR_API_GATEWAY_URL';  // Replace this
   ```
   - Commit and push the change - Amplify will auto-redeploy

### Option B: Deploy via AWS CLI

1. **Install Amplify CLI**
   ```bash
   npm install -g @aws-amplify/cli
   amplify configure
   ```

2. **Initialize Amplify**
   ```bash
   amplify init
   # Follow prompts:
   # - App name: job-rag-system
   # - Environment: prod
   # - Editor: VSCode
   # - Type: JavaScript
   # - Framework: None
   # - Source directory: .
   # - Distribution directory: .
   # - Build command: (leave empty)
   # - Start command: (leave empty)
   ```

3. **Add Hosting**
   ```bash
   amplify add hosting
   # Choose: Hosting with Amplify Console
   # Choose: Manual deployment
   ```

4. **Publish**
   ```bash
   amplify publish
   ```

---

## Part 2: Deploy Backend API to AWS Lambda

### Step 1: Prepare Lambda Package

1. **Create a lambda directory**
   ```powershell
   mkdir lambda
   cd lambda
   ```

2. **Create Lambda handler**
   Create `lambda/lambda_function.py`:
   ```python
   import json
   import os
   import sys
   
   # Add the vendor directory to path
   sys.path.insert(0, '/opt/python')
   sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'packages'))
   
   from rag_system import JobRAGSystem
   
   # Initialize RAG system (done once per Lambda container)
   rag_system = None
   
   def lambda_handler(event, context):
       global rag_system
       
       # Initialize on first request
       if rag_system is None:
           rag_system = JobRAGSystem(embeddings_dir='/tmp/embeddings')
       
       # Enable CORS
       headers = {
           'Access-Control-Allow-Origin': '*',
           'Access-Control-Allow-Headers': 'Content-Type',
           'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
       }
       
       # Handle preflight
       if event.get('httpMethod') == 'OPTIONS':
           return {
               'statusCode': 200,
               'headers': headers,
               'body': ''
           }
       
       try:
           # Parse request
           path = event.get('path', '')
           method = event.get('httpMethod', '')
           body = json.loads(event.get('body', '{}'))
           
           # Health check
           if path == '/api/health' and method == 'GET':
               return {
                   'statusCode': 200,
                   'headers': headers,
                   'body': json.dumps({
                       'status': 'healthy',
                       'message': 'Job RAG API is running'
                   })
               }
           
           # Search endpoint
           if path == '/api/search' and method == 'POST':
               query = body.get('query')
               top_k = body.get('top_k', 5)
               
               if not query:
                   return {
                       'statusCode': 400,
                       'headers': headers,
                       'body': json.dumps({'error': 'Missing query'})
                   }
               
               result = rag_system.query(query, top_k=top_k)
               
               return {
                   'statusCode': 200,
                   'headers': headers,
                   'body': json.dumps({
                       'success': True,
                       'data': result
                   })
               }
           
           return {
               'statusCode': 404,
               'headers': headers,
               'body': json.dumps({'error': 'Not found'})
           }
           
       except Exception as e:
           return {
               'statusCode': 500,
               'headers': headers,
               'body': json.dumps({
                   'error': str(e),
                   'success': False
               })
           }
   ```

3. **Create requirements file for Lambda**
   Create `lambda/requirements.txt`:
   ```
   numpy
   faiss-cpu
   openai
   python-dotenv
   ```

### Step 2: Upload Embeddings to S3

1. **Create S3 bucket**
   ```bash
   aws s3 mb s3://job-rag-embeddings-YOUR_UNIQUE_ID
   ```

2. **Upload embeddings**
   ```bash
   aws s3 cp embeddings/ s3://job-rag-embeddings-YOUR_UNIQUE_ID/embeddings/ --recursive
   ```

### Step 3: Build Lambda Layer for Dependencies

1. **Create layer directory**
   ```powershell
   mkdir lambda-layer
   cd lambda-layer
   mkdir python
   ```

2. **Install dependencies**
   ```powershell
   pip install -r ../requirements.txt -t python/
   ```

3. **Create layer zip**
   ```powershell
   Compress-Archive -Path python -DestinationPath lambda-layer.zip
   ```

4. **Upload layer to AWS**
   ```bash
   aws lambda publish-layer-version `
     --layer-name job-rag-dependencies `
     --description "Dependencies for Job RAG system" `
     --zip-file fileb://lambda-layer.zip `
     --compatible-runtimes python3.11
   ```

### Step 4: Create Lambda Function

1. **Zip your Lambda code**
   ```powershell
   cd ../lambda
   Copy-Item ../rag_system.py .
   Compress-Archive -Path lambda_function.py,rag_system.py -DestinationPath function.zip
   ```

2. **Create Lambda function via AWS Console**
   - Go to [AWS Lambda Console](https://console.aws.amazon.com/lambda/)
   - Click **"Create function"**
   - Name: `job-rag-api`
   - Runtime: Python 3.11
   - Architecture: x86_64
   - Role: Create new role with basic Lambda permissions
   - Click **"Create function"**

3. **Upload your code**
   - In the Lambda console, click **"Upload from"** → **".zip file"**
   - Upload `function.zip`

4. **Add Lambda Layer**
   - Scroll to **"Layers"** section
   - Click **"Add a layer"**
   - Select **"Custom layers"**
   - Choose the layer you created earlier
   - Click **"Add"**

5. **Configure Lambda**
   - **Memory**: 2048 MB (for FAISS operations)
   - **Timeout**: 30 seconds
   - **Environment variables**:
     ```
     OPENAI_API_KEY=your_openai_api_key
     S3_BUCKET=job-rag-embeddings-YOUR_UNIQUE_ID
     ```

6. **Add S3 download to Lambda**
   Update `lambda_function.py` to download embeddings from S3 on cold start:
   ```python
   import boto3
   
   def download_embeddings_from_s3():
       s3 = boto3.client('s3')
       bucket = os.getenv('S3_BUCKET')
       
       os.makedirs('/tmp/embeddings', exist_ok=True)
       
       files = ['embeddings.npy', 'faiss_index.bin', 'metadata.pkl']
       for file in files:
           s3.download_file(bucket, f'embeddings/{file}', f'/tmp/embeddings/{file}')
   ```

### Step 5: Create API Gateway

1. **Create REST API**
   - Go to [API Gateway Console](https://console.aws.amazon.com/apigateway/)
   - Click **"Create API"** → **"REST API"** → **"Build"**
   - Name: `job-rag-api`
   - Click **"Create API"**

2. **Create Resources**
   - Click **"Actions"** → **"Create Resource"**
   - Resource name: `api`
   - Click **"Create Resource"**
   - Select `/api` and create child resources:
     - `/api/health` (GET)
     - `/api/search` (POST)

3. **Connect to Lambda**
   - For each resource, click **"Actions"** → **"Create Method"**
   - Choose method type (GET or POST)
   - Integration type: Lambda Function
   - Lambda Function: `job-rag-api`
   - Save and confirm permissions

4. **Enable CORS**
   - Select each resource
   - Click **"Actions"** → **"Enable CORS"**
   - Use default settings
   - Click **"Enable CORS and replace existing headers"**

5. **Deploy API**
   - Click **"Actions"** → **"Deploy API"**
   - Stage: `prod`
   - Click **"Deploy"**
   - Copy the **Invoke URL** (e.g., `https://abc123.execute-api.us-east-1.amazonaws.com/prod`)

---

## Part 3: Update Frontend Configuration

1. **Update index.html with your API Gateway URL**
   ```javascript
   const API_URL = 'https://YOUR_API_GATEWAY_URL.execute-api.REGION.amazonaws.com/prod';
   ```

2. **Commit and push** (if using GitHub integration with Amplify)
   ```bash
   git add index.html
   git commit -m "Update API URL for production"
   git push
   ```

---

## Alternative: Simple Deployment with AWS Amplify + EC2

If Lambda is too complex, you can deploy the backend on EC2:

### Deploy Backend on EC2

1. **Launch EC2 Instance**
   - Ubuntu Server 22.04 LTS
   - t3.small or larger
   - Allow HTTP/HTTPS in security group

2. **SSH and setup**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install Python
   sudo apt install python3-pip python3-venv -y
   
   # Clone your repo
   git clone YOUR_REPO_URL
   cd aws_rag
   
   # Setup virtual environment
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   
   # Set environment variables
   export OPENAI_API_KEY=your_key_here
   
   # Run with Gunicorn
   pip install gunicorn
   gunicorn -w 4 -b 0.0.0.0:5000 api:app
   ```

3. **Setup Nginx reverse proxy**
   ```bash
   sudo apt install nginx -y
   
   # Configure Nginx
   sudo nano /etc/nginx/sites-available/job-rag
   ```
   
   Add:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;
       
       location / {
           proxy_pass http://127.0.0.1:5000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```
   
   Enable:
   ```bash
   sudo ln -s /etc/nginx/sites-available/job-rag /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

4. **Setup SSL with Let's Encrypt**
   ```bash
   sudo apt install certbot python3-certbot-nginx -y
   sudo certbot --nginx -d your-domain.com
   ```

---

## Costs Estimate

### AWS Amplify (Frontend)
- **Free tier**: 1,000 build minutes/month, 15 GB storage
- **After free tier**: ~$0.01 per build minute, $0.15/GB storage

### AWS Lambda + API Gateway (Backend)
- **Lambda Free tier**: 1M requests/month, 400,000 GB-seconds
- **API Gateway**: $3.50 per million requests
- **Typical cost**: $0-5/month for low traffic

### S3 (Embeddings Storage)
- **Storage**: $0.023/GB/month (~$0.02/month for your data)
- **Requests**: Negligible for this use case

### EC2 Alternative
- **t3.small**: ~$15/month (24/7)
- **Elastic IP**: Free while instance is running

**Total estimated cost**: $5-20/month depending on traffic

---

## Testing Your Deployment

1. **Test API directly**
   ```bash
   curl -X POST https://YOUR_API_URL/api/search \
     -H "Content-Type: application/json" \
     -d '{"query": "data analyst jobs", "top_k": 3}'
   ```

2. **Test frontend**
   - Open your Amplify URL
   - Try searching for jobs
   - Check browser console for errors

---

## Troubleshooting

### CORS Issues
- Ensure CORS is enabled in API Gateway
- Check Lambda response includes CORS headers
- Clear browser cache

### Lambda Timeout
- Increase Lambda timeout to 30 seconds
- Increase memory to 2048 MB
- Consider caching embeddings in /tmp

### Large Embeddings File
- If embeddings exceed Lambda size limits:
  - Store in S3 and download on cold start
  - Use EFS (Elastic File System) mounted to Lambda
  - Consider Lambda@Edge with CloudFront

### API Not Found
- Check API Gateway deployment stage
- Verify resource paths match exactly
- Check Lambda permissions

---

## Security Best Practices

1. **API Key Protection**
   - Store OpenAI API key in AWS Secrets Manager
   - Access via Lambda IAM role
   - Rotate keys regularly

2. **Rate Limiting**
   - Enable API Gateway throttling
   - Set per-user quotas
   - Use AWS WAF for protection

3. **Authentication** (Optional)
   - Add Cognito authentication
   - Require API keys for requests
   - Implement JWT tokens

---

## Monitoring

1. **CloudWatch Logs**
   - Lambda logs available in CloudWatch
   - Set up alerts for errors
   - Monitor API Gateway metrics

2. **AWS X-Ray**
   - Enable tracing for Lambda
   - Visualize request flows
   - Identify bottlenecks

---

## Next Steps

1. ✅ Deploy frontend to Amplify
2. ✅ Deploy backend to Lambda
3. ✅ Connect with API Gateway
4. ✅ Update frontend API URL
5. ✅ Test thoroughly
6. 🎉 Share your app!

Need help? Check AWS documentation or create an issue in your repo!
