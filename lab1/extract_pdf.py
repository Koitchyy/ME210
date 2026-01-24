import pypdf
import sys

try:
    reader = pypdf.PdfReader("/Users/koichikimoto/Desktop/Academics/ME210/lab1/ME_210_Lab_1_W26.1.pdf")
    print(f"Total pages: {len(reader.pages)}")
    for i, page in enumerate(reader.pages):
        print(f"--- Page {i+1} ---")
        print(page.extract_text())
except Exception as e:
    print(f"Error: {e}")
