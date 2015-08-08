#list all '*.jpg' in current folder

import os

filelist = os.listdir()
found = 0
for i in filelist:
    if os.path.splitext(i)[1].upper() == '.JPG':
       print(" found " , i )
       found = 1

if found == 0:
    print (" Not found any *.jpg files ")
