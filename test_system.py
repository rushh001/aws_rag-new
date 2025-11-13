"""
Test script to verify RAG system functionality
Run this after generating embeddings to ensure everything works
"""

import os
import sys
from dotenv import load_dotenv

def check_requirements():
    """Check if all requirements are met"""
    print("=" * 60)
    print("CHECKING REQUIREMENTS")
    print("=" * 60)
    
    # Check .env file
    if not os.path.exists('.env'):
        print("❌ .env file not found!")
        print("   Create .env file with: OPENAI_API_KEY=your-key")
        return False
    print("✓ .env file exists")
    
    # Load and check API key
    load_dotenv()
    api_key = os.getenv('OPENAI_API_KEY')
    if not api_key or api_key == 'your_openai_api_key_here':
        print("❌ OpenAI API key not configured!")
        print("   Edit .env and add your API key")
        return False
    print("✓ OpenAI API key configured")
    
    # Check embeddings directory
    if not os.path.exists('embeddings'):
        print("❌ Embeddings directory not found!")
        print("   Run: python generate_embeddings.py")
        return False
    print("✓ Embeddings directory exists")
    
    # Check embedding files
    required_files = ['embeddings.npy', 'faiss_index.bin', 'metadata.pkl']
    for file in required_files:
        file_path = os.path.join('embeddings', file)
        if not os.path.exists(file_path):
            print(f"❌ Missing file: {file}")
            print("   Run: python generate_embeddings.py")
            return False
    print("✓ All embedding files present")
    
    # Check dataset
    if not os.path.exists('seek_jobs (4).csv'):
        print("❌ Dataset file not found!")
        return False
    print("✓ Dataset file exists")
    
    return True

def test_rag_system():
    """Test RAG system with sample queries"""
    print("\n" + "=" * 60)
    print("TESTING RAG SYSTEM")
    print("=" * 60)
    
    try:
        from rag_system import JobRAGSystem
        print("✓ RAG system imported successfully")
        
        print("\nInitializing RAG system...")
        rag = JobRAGSystem()
        print("✓ RAG system initialized")
        
        # Test query
        print("\nRunning test query...")
        test_query = "data analyst jobs in Brisbane"
        print(f"Query: '{test_query}'")
        
        result = rag.query(test_query, top_k=3)
        
        print("\n✓ Query executed successfully!")
        print(f"\nResults:")
        print(f"  - Found {result['total_jobs_found']} jobs")
        print(f"  - AI response length: {len(result['ai_response'])} characters")
        print(f"  - Top job: {result['jobs'][0]['job_title']}")
        print(f"  - Similarity score: {result['jobs'][0]['similarity_score']:.2f}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error testing RAG system: {e}")
        import traceback
        traceback.print_exc()
        return False

def test_api():
    """Test if API can be imported"""
    print("\n" + "=" * 60)
    print("TESTING API MODULE")
    print("=" * 60)
    
    try:
        import api
        print("✓ API module imported successfully")
        print("\nTo start the API server, run:")
        print("  python api.py")
        return True
    except Exception as e:
        print(f"❌ Error importing API: {e}")
        return False

def main():
    """Run all tests"""
    print("\n" + "=" * 60)
    print("JOB RAG SYSTEM - VERIFICATION TEST")
    print("=" * 60 + "\n")
    
    # Check requirements
    if not check_requirements():
        print("\n❌ Requirements check failed!")
        print("Please fix the issues above and try again.")
        sys.exit(1)
    
    # Test RAG system
    if not test_rag_system():
        print("\n❌ RAG system test failed!")
        sys.exit(1)
    
    # Test API
    test_api()
    
    # Success!
    print("\n" + "=" * 60)
    print("✅ ALL TESTS PASSED!")
    print("=" * 60)
    print("\nYour RAG system is ready to use!")
    print("\nNext steps:")
    print("1. Start the API: python api.py")
    print("2. Start the frontend: cd frontend && npm start")
    print("3. Open http://localhost:3000 in your browser")
    print("\nHappy job hunting! 🎯")

if __name__ == "__main__":
    main()
