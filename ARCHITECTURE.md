# System Architecture & Flow

## High-Level Architecture

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                     USER INTERFACE                      ┃
┃                                                          ┃
┃  ┌────────────────────────────────────────────────┐    ┃
┃  │         React Frontend (Port 3000)              │    ┃
┃  │  ┌──────────────────────────────────────────┐  │    ┃
┃  │  │  Search Bar + Example Queries            │  │    ┃
┃  │  │  AI Insights Display                     │  │    ┃
┃  │  │  Job Cards with Similarity Scores        │  │    ┃
┃  │  └──────────────────────────────────────────┘  │    ┃
┃  └────────────────────────────────────────────────┘    ┃
┗━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                       │ HTTP REST API
                       │
┏━━━━━━━━━━━━━━━━━━━━━▼━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                   API LAYER (Port 5000)                 ┃
┃                                                          ┃
┃  ┌────────────────────────────────────────────────┐    ┃
┃  │          Flask REST API (api.py)                │    ┃
┃  │  ┌──────────────────────────────────────────┐  │    ┃
┃  │  │ GET  /api/health                         │  │    ┃
┃  │  │ POST /api/search                         │  │    ┃
┃  │  │ POST /api/similar-jobs                   │  │    ┃
┃  │  │ GET  /api/stats                          │  │    ┃
┃  │  └──────────────────────────────────────────┘  │    ┃
┃  └────────────────────────────────────────────────┘    ┃
┗━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                       │
                       │
┏━━━━━━━━━━━━━━━━━━━━━▼━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                  RAG LOGIC LAYER                        ┃
┃                                                          ┃
┃  ┌────────────────────────────────────────────────┐    ┃
┃  │      RAG System (rag_system.py)                 │    ┃
┃  │  ┌──────────────────────────────────────────┐  │    ┃
┃  │  │ 1. Embed user query                      │  │    ┃
┃  │  │ 2. Search FAISS index                    │  │    ┃
┃  │  │ 3. Retrieve top-k jobs                   │  │    ┃
┃  │  │ 4. Generate AI insights                  │  │    ┃
┃  │  │ 5. Return structured results             │  │    ┃
┃  │  └──────────────────────────────────────────┘  │    ┃
┃  └────────────────────────────────────────────────┘    ┃
┗━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━┛
               │                      │
               │                      │
      ┌────────▼────────┐    ┌───────▼────────┐
      │                 │    │                 │
┏━━━━━▼━━━━━━━━━━━━━━━━▼━━━━▼━━━━━━━━━━━━━━━▼━━━━━━━━┓
┃              DATA & AI SERVICES                        ┃
┃                                                         ┃
┃  ┌──────────────────┐       ┌─────────────────────┐  ┃
┃  │  Local Storage   │       │   OpenAI API        │  ┃
┃  │                  │       │                     │  ┃
┃  │  embeddings/     │       │  text-embedding-    │  ┃
┃  │  ├─ .npy         │       │  3-small            │  ┃
┃  │  ├─ .bin (FAISS) │       │                     │  ┃
┃  │  └─ .pkl         │       │  gpt-4o-mini        │  ┃
┃  │                  │       │                     │  ┃
┃  └──────────────────┘       └─────────────────────┘  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

## Data Flow - Query Process

```
User enters query: "data analyst jobs in Brisbane"
         │
         ▼
┌────────────────────────────────────────┐
│  1. FRONTEND CAPTURES QUERY            │
│     - User types in search box         │
│     - Selects top_k (3, 5, or 10)     │
│     - Clicks "Search Jobs"             │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  2. API REQUEST                        │
│     POST /api/search                   │
│     {                                  │
│       "query": "data analyst...",      │
│       "top_k": 5                       │
│     }                                  │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  3. EMBED QUERY                        │
│     - Send query to OpenAI             │
│     - Get embedding vector             │
│     - Vector dimension: 1536           │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  4. VECTOR SEARCH                      │
│     - Query FAISS index                │
│     - Find 5 most similar jobs         │
│     - Calculate similarity scores      │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  5. RETRIEVE JOB DETAILS               │
│     - Get metadata from .pkl           │
│     - Include all job fields           │
│     - Rank by similarity               │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  6. GENERATE AI INSIGHTS               │
│     - Build context from 5 jobs        │
│     - Send to GPT-4o-mini              │
│     - Get personalized response        │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  7. RETURN RESULTS                     │
│     {                                  │
│       "ai_response": "...",            │
│       "jobs": [...],                   │
│       "total_jobs_found": 5            │
│     }                                  │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  8. DISPLAY IN UI                      │
│     - Show AI insights                 │
│     - Render job cards                 │
│     - Display similarity scores        │
│     - Provide "View Job" links         │
└────────────────────────────────────────┘
```

## Embedding Generation Process

```
CSV File: seek_jobs (4).csv
         │
         ▼
┌────────────────────────────────────────┐
│  1. LOAD DATA                          │
│     - Read CSV with pandas             │
│     - Create combined text field       │
│     - Merge title, company, desc, etc  │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  2. BATCH PROCESSING                   │
│     - Split into batches of 100        │
│     - Process sequentially             │
│     - Rate limit: 0.5s between batches │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  3. GENERATE EMBEDDINGS                │
│     For each batch:                    │
│     - Send to OpenAI API               │
│     - Model: text-embedding-3-small    │
│     - Get 1536-dim vectors             │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  4. CREATE FAISS INDEX                 │
│     - Convert to numpy array           │
│     - Create IndexFlatL2               │
│     - Add all vectors to index         │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  5. SAVE TO DISK                       │
│     embeddings/                        │
│     ├─ embeddings.npy    (vectors)     │
│     ├─ faiss_index.bin   (search idx)  │
│     ├─ metadata.pkl      (job data)    │
│     └─ metadata_sample.json (preview)  │
└────────────────────────────────────────┘
```

## Component Dependencies

```
┌─────────────────────────────────────────────┐
│              generate_embeddings.py         │
│  Dependencies:                              │
│  • openai (API client)                      │
│  • pandas (data processing)                 │
│  • numpy (arrays)                           │
│  • faiss (vector search)                    │
│  • pickle (serialization)                   │
└───────────────┬─────────────────────────────┘
                │ creates
                ▼
┌─────────────────────────────────────────────┐
│              embeddings/                    │
│  • embeddings.npy                           │
│  • faiss_index.bin                          │
│  • metadata.pkl                             │
└───────────────┬─────────────────────────────┘
                │ used by
                ▼
┌─────────────────────────────────────────────┐
│              rag_system.py                  │
│  Dependencies:                              │
│  • openai (query embedding + GPT)           │
│  • numpy (vector operations)                │
│  • faiss (similarity search)                │
│  • pickle (load metadata)                   │
└───────────────┬─────────────────────────────┘
                │ used by
                ▼
┌─────────────────────────────────────────────┐
│              api.py                         │
│  Dependencies:                              │
│  • flask (web server)                       │
│  • flask-cors (CORS support)                │
│  • rag_system (RAG logic)                   │
└───────────────┬─────────────────────────────┘
                │ called by
                ▼
┌─────────────────────────────────────────────┐
│              frontend/src/App.js            │
│  Dependencies:                              │
│  • react (UI framework)                     │
│  • axios (HTTP client)                      │
└─────────────────────────────────────────────┘
```

## File I/O Patterns

```
┌──────────────┐  read   ┌──────────────┐
│ CSV Dataset  ├────────►│  Embeddings  │
└──────────────┘         │  Generator   │
                         └──────┬───────┘
                                │ write
                                ▼
                         ┌──────────────┐
                         │ embeddings/  │
                         │  ├─ .npy     │
                         │  ├─ .bin     │
                         │  └─ .pkl     │
                         └──────┬───────┘
                                │ read
                                ▼
                         ┌──────────────┐
                         │ RAG System   │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │  API Server  │
                         └──────┬───────┘
                                │ HTTP
                                ▼
                         ┌──────────────┐
                         │  Frontend    │
                         └──────────────┘
```

## Deployment Architecture (AWS)

```
┌─────────────────────────────────────────────────┐
│                   Internet                      │
└────────────┬────────────────────┬───────────────┘
             │                    │
             │                    │
    ┌────────▼────────┐  ┌────────▼────────┐
    │  AWS Amplify    │  │  AWS Lambda/EC2  │
    │  (Frontend)     │  │  (Backend API)   │
    │                 │  │                  │
    │  • React App    │  │  • Flask API     │
    │  • Auto SSL     │  │  • RAG System    │
    │  • CDN          │  │  • Embeddings    │
    └─────────────────┘  └──────────────────┘
```

## Technology Stack Layers

```
┌─────────────────────────────────────────────┐
│         USER INTERFACE LAYER                │
│  React • CSS3 • Modern JavaScript           │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│         API / SERVER LAYER                  │
│  Flask • REST API • CORS                    │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│         BUSINESS LOGIC LAYER                │
│  RAG System • Query Processing              │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│         DATA / STORAGE LAYER                │
│  FAISS • NumPy • Pickle • CSV               │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│         EXTERNAL SERVICES                   │
│  OpenAI API (Embeddings + GPT-4)            │
└─────────────────────────────────────────────┘
```

## Request/Response Cycle Times

```
User Query → Frontend          : ~10ms
Frontend → API                 : ~20ms
API → Embed Query (OpenAI)     : ~200ms
Query → FAISS Search           : ~5ms
Retrieve Job Metadata          : ~2ms
Generate AI Response (OpenAI)  : ~1000ms
API → Frontend                 : ~20ms
Frontend Render                : ~50ms
────────────────────────────────────────
Total Time                     : ~1.3s
```

## Security Layers

```
┌─────────────────────────────────────────────┐
│  1. HTTPS/TLS (Transport Security)          │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  2. CORS (Cross-Origin Protection)          │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  3. Environment Variables (Secret Mgmt)     │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  4. API Key Authentication (OpenAI)         │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  5. Input Validation (Request Validation)   │
└─────────────────────────────────────────────┘
```

This architecture provides a robust, scalable, and maintainable RAG system!
