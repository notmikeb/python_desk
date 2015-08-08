import os
from PIL import Image

#use first picture as the left side, others as the right side

# 1.jpg, 2.jpg, 3.jpg
if len(os.sys.argv) < 2:
  print ("error " )
  exit()

i = os.sys.argv[1]
print ( i )
im1 = Image.open(i)
print ( "size : ", im1.size, " format:", im1.format)
x, y = im1.size
im9 = im1.crop((int(x/4), 0, int(x*3/4), y))

im1.paste(im9, (0,0, int(x/2), y))
del im9

num = len(os.sys.argv[2:])
count = 0
print ("num is ", num)
for i in os.sys.argv[2:]:
  print ( i )
  im2 = Image.open(i)
  # has num pictures
  im2 = im2.resize((int(x/2), int(y/num) ))
  print ( "resize ", im2.size,  " int (x/2), int (y/num) ", int(x/2), int(y/num) )
  im1.paste(im2, (int(x/2), 0+ int(y/num) * count, int(x/2) + im2.size[0], int(y/num) * (count) + im2.size[1]))
  del im2  
  count = count + 1

print (" put " , num, " pictures together")
im1.save('all.jpg')   

print ("done.....")
