import asyncio
from extractor import extract_and_index_all_books

if __name__ == "__main__":
    print("Starting initial book indexing...")
    asyncio.run(extract_and_index_all_books())
    print("Initial indexing finished!")
