# VNULIB Downloader

_@Version 1, 2023-03-07_

A Batch Script for Downloading E-Books from [ir.vnulib.edu.vn](https://ir.vnulib.edu.vn/).

## Overview:

<p align="center">
  <img src="https://static.vnuhcm.edu.vn/images/0%20Phong%204T/2019/Thang%205/19.05.21%20-%20Logo%20don-03%20(1).png" alt="logo"/>
</p>

VNULIB Downloader is a batch script that automates the downloading of e-books from [ir.vnulib.edu.vn](https://ir.vnulib.edu.vn/). The script is written in batch language and uses the curl command-line tool to download the e-book pages in JPG format.

## Usage:

1. Download the batch file *(downloader.bat)* to your local computer.
2. Double-click the file to run it.
3. Enter the link to the e-book, the starting page number, and the ending page number when prompted.
Ex:
````
LINK: https://ir.vnulib.edu.vn/flowpaper/simple_document.php?subfolder=16/63/92/&doc=1663925828253380950770207071513029111&bitsid=b3c4ca73-22a2-4eda-a62a-acfc314470eb&uid=f5c8452e-f096-4ed8-bf5c-2a92357b9db7

FROM PAGE: 1

TO PAGE: 302
````


5. The script will create a new directory named *"vnulib_downloader"* in the same location as the batch file and download the e-book pages to a subdirectory named *"image"* within this directory.
6. The downloaded pages will be saved in JPG format with the filename *"page_i.jpg"* where *"i"* is the page number.

## Requirements:

1. Windows operating system
2. curl command-line tool (downloadable from https://curl.se/)

## Disclaimer:

The script is provided "as is" without warranty of any kind. The author is not responsible for any damages or losses resulting from the use of the script.

## License:

The script is released under the MIT license.
