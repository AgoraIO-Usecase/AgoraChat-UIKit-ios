import os
import sys
import requests
import zipfile
import shutil
from urllib.parse import urlparse

def download_file(url, filename):
    response = requests.get(url, stream=True)
    response.raise_for_status()
    with open(filename, 'wb') as file:
        for chunk in response.iter_content(chunk_size=8192):
            file.write(chunk)

def extract_zip(zip_path, extract_to):
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_to)

def replace_folder_contents(source, destination):
    if os.path.exists(destination):
        shutil.rmtree(destination)
    shutil.copytree(source, destination)

def main(url):
    # 获取URL中的文件名
    filename = os.path.basename(urlparse(url).path)
    
    # 下载文件
    print(f"Downloading {filename}...")
    download_file(url, filename)
    
    # 解压文件
    print("Extracting files...")
    temp_dir = "temp_extract"
    extract_zip(filename, temp_dir)
    
    # 替换文件夹内容
    destination = os.path.join("Pods", "Agora_Chat_iOS")
    print(f"Replacing contents in {destination}...")
    replace_folder_contents(temp_dir, destination)
    
    # 清理临时文件
    os.remove(filename)
    shutil.rmtree(temp_dir)
    
    print("Operation completed successfully!")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <url>")
        sys.exit(1)
    
    url = sys.argv[1]
    main(url)
