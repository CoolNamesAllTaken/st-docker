import sys
import gdown

if len(sys.argv) != 3:
    print("Usage: python download_drive_file.py url file_out")
    exit(1)

# Retrieving command-line arguments
url = sys.argv[1]
file_out = sys.argv[2]

# Printing the arguments
print(f"Downloading file from URL: {url} and saving as filename {file_out}")
gdown.download(url, file_out)