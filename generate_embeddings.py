import pandas as pd
import numpy as np
import json
import os
from openai import OpenAI
from dotenv import load_dotenv
import pickle
import faiss
from typing import List, Dict
import time

# Load environment variables
load_dotenv()

class JobEmbeddingGenerator:
    def __init__(self, csv_path: str, embeddings_dir: str = "embeddings"):
        """
        Initialize the embedding generator
        
        Args:
            csv_path: Path to the CSV file with job data
            embeddings_dir: Directory to store embeddings
        """
        self.client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.csv_path = csv_path
        self.embeddings_dir = embeddings_dir
        self.df = None
        self.embeddings = None
        self.index = None
        
        # Create embeddings directory if it doesn't exist
        os.makedirs(embeddings_dir, exist_ok=True)
        
    def load_data(self):
        """Load and preprocess the job data"""
        print("Loading job data...")
        self.df = pd.read_csv(self.csv_path)
        print(f"Loaded {len(self.df)} job records")
        
        # Create a combined text field for embedding
        self.df['combined_text'] = self.df.apply(
            lambda row: f"""
            Job Title: {row['job_title']}
            Company: {row['company_name']}
            Location: {row['location']}
            Salary: {row['salary']}
            Industry: {row['industry_type']}
            Classification: {row['sub_classification']}
            Job Type: {row['job_type']}
            Description: {row['description']}
            """.strip(),
            axis=1
        )
        
    def generate_embeddings(self, batch_size: int = 100):
        """
        Generate embeddings for all jobs
        
        Args:
            batch_size: Number of jobs to process at once
        """
        print("Generating embeddings...")
        embeddings = []
        
        for i in range(0, len(self.df), batch_size):
            batch = self.df['combined_text'].iloc[i:i+batch_size].tolist()
            print(f"Processing batch {i//batch_size + 1}/{(len(self.df)-1)//batch_size + 1}")
            
            try:
                response = self.client.embeddings.create(
                    model="text-embedding-3-small",
                    input=batch
                )
                
                batch_embeddings = [item.embedding for item in response.data]
                embeddings.extend(batch_embeddings)
                
                # Rate limiting to avoid API throttling
                time.sleep(0.5)
                
            except Exception as e:
                print(f"Error processing batch: {e}")
                # Add None placeholders for failed batch
                embeddings.extend([None] * len(batch))
        
        self.embeddings = np.array([e for e in embeddings if e is not None], dtype=np.float32)
        print(f"Generated {len(self.embeddings)} embeddings")
        
    def create_faiss_index(self):
        """Create FAISS index for fast similarity search"""
        print("Creating FAISS index...")
        dimension = self.embeddings.shape[1]
        
        # Using IndexFlatL2 for exact search (can be optimized for larger datasets)
        self.index = faiss.IndexFlatL2(dimension)
        self.index.add(self.embeddings)
        print(f"Index created with {self.index.ntotal} vectors")
        
    def save_embeddings(self):
        """Save embeddings, index, and metadata to disk"""
        print("Saving embeddings locally...")
        
        # Save embeddings as numpy array
        embeddings_path = os.path.join(self.embeddings_dir, "embeddings.npy")
        np.save(embeddings_path, self.embeddings)
        
        # Save FAISS index
        index_path = os.path.join(self.embeddings_dir, "faiss_index.bin")
        faiss.write_index(self.index, index_path)
        
        # Save metadata (dataframe without embeddings)
        metadata_path = os.path.join(self.embeddings_dir, "metadata.pkl")
        with open(metadata_path, 'wb') as f:
            pickle.dump(self.df, f)
        
        # Save a JSON version for easy inspection
        json_path = os.path.join(self.embeddings_dir, "metadata_sample.json")
        self.df.head(10).to_json(json_path, orient='records', indent=2)
        
        print(f"Embeddings saved to {self.embeddings_dir}")
        
    def run_pipeline(self):
        """Run the complete embedding generation pipeline"""
        self.load_data()
        self.generate_embeddings()
        self.create_faiss_index()
        self.save_embeddings()
        print("Pipeline complete!")


if __name__ == "__main__":
    # Initialize and run the embedding generator
    generator = JobEmbeddingGenerator("seek_jobs (4).csv")
    generator.run_pipeline()
