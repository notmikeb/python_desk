copy /y C:\Python34\Lib\site-packages\PyQt5\libEGL.dll .
mkdir platforms
copy  /y C:\Python34\Lib\site-packages\PyQt5\plugins\platforms\qwindows.dll platforms\
copy /y *.jpg dist\
copy /y *.png dist\
copy /y *.ico dist\