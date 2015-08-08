#list all '*.jpg' in current folder

import os

filelist = os.listdir()
for i in filelist:
    if os.path.splitext(i)[1].upper() == '.JPG':
       print(" found " , i )
