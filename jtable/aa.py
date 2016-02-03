import base64
def encode(key, clear):
    enc = []
    for i in range(len(clear)):
        key_c = key[i % len(key)]
        enc_c = chr((ord(clear[i]) + ord(key_c)) % 256)
        enc.append(enc_c)
    return base64.standard_b64encode("".join(enc))

def decode(key, enc):
    dec = []
    enc = base64.standard_b64decode(enc)
    for i in range(len(enc)):
        key_c = key[i % len(key)]
        dec_c = chr((256 + ord(enc[i]) - ord(key_c)) % 256)
        dec.append(dec_c)
    return "".join(dec)

keyi = '31'
text = '1234567890'
data = encode(keyi, text)
print(text, data)
print(decode(keyi, data))

import sys
if len(sys.argv) > 2:
  print(sys.argv)
  i = sys.argv[2]
  o = sys.argv[3]
  if sys.argv[1] == 'x':
    funptr = encode
    print( 'endcode')
  else:
    funptr = decode
    print ('decode')
  print (i, o)
  f = open(i, 'r')
  text = f.read()
  of = open(o, 'w')
  data = funptr(keyi, text)
  of.write(data)
  print (text[0:10], data[0:10])
  f.close()
  of.close()

