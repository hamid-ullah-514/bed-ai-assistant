import pypdf
import os

pdf_dir = r"D:\AI corse\b.ed\8606"
out_pdf = r"D:\AI corse\b.ed\8606.pdf"

if not os.path.exists(out_pdf):
    merger = pypdf.PdfWriter()
    
    files = [
        "Introduction & Contents.pdf",
        "8606 Unit 1.pdf",
        "8606 Unit 2.pdf",
        "8606 Unit 3.pdf",
        "8606 Unit 4.pdf",
        "8606 Unit 5.pdf",
        "8606 Unit 6.pdf",
        "8606 Unit 7.pdf",
        "8606 Unit 8.pdf",
        "8606 Unit 9.pdf"
    ]
    
    for f in files:
        full_path = os.path.join(pdf_dir, f)
        if os.path.exists(full_path):
            print(f"Adding {f}...")
            merger.append(full_path)
        else:
            print(f"Warning: {f} not found!")
            
    with open(out_pdf, "wb") as f_out:
        merger.write(f_out)
    merger.close()
    print(f"Successfully created {out_pdf}")
else:
    print(f"{out_pdf} already exists.")
