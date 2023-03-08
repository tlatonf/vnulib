@echo off
setlocal EnableDelayedExpansion

set file=link.txt
set count=0

for /f "tokens=*" %%a in (%file%) do (
    set /a count+=1
    set url=%%a
    echo Downloading image !count!
    curl !url! --output image\image!count!.jpg
)

echo All images downloaded successfully.
pause
