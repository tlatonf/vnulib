@echo off
setlocal EnableDelayedExpansion

set	file=link.txt
set 	count=0
set 	line=0

for /f "tokens=*" %%a in (%file%) do (
    	set /a line+=1
    	if !line! geq 1 (
      set /a count+=1
      set url=%%a
      echo Downloading image !count!
      curl !url! --output image\image!count!.jpg
	cls
    )
)

echo All images downloaded successfully.

pause
