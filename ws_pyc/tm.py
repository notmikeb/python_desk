#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ctypes
from ctypes import *
#study link http://starship.python.net/crew/theller/ctypes/tutorial.html#return-types
#sample tutorial http://tw.tonytuan.org/2008/10/cc-timetstruct-tm.html
# dictionary https://docs.python.org/3/library/ctypes.html

libc = ctypes.cdll.LoadLibrary('libc.so.6')
libc.time(None)

class pytm(ctypes.Structure):
    _fields_ = [
             ('tm_sec', ctypes.c_int),
             ('tm_min', ctypes.c_int),
             ('tm_hour', ctypes.c_int),
             ('tm_mday', c_int),
             ('tm_mon', c_int),
             ('tm_year', c_int),
             ('tm_wday', c_int),
             ('tm_yday', c_int),
             ('tm_isdst', c_int),
             ('tm_gmtoff', c_long),
             ('tm_zone', c_char_p)
            ]

def showdatetime(tm2):
    print ( 'date time is ', 1900+ tm2.tm_year, tm2.tm_mon+1, tm2.tm_mday, tm2.tm_hour, tm2.tm_min, tm2.tm_sec)

tm1 = pytm()
print( 'asctime is ',  c_char_p(libc.asctime(byref(tm1))).value)
libc.mktime(byref(tm1))
print( tm1.tm_sec, tm1.tm_year)

# struct tm *gmtime( time_t *t)
t1 = c_long( libc.time(None) )
gmtime = libc.gmtime
gmtime.argtypes = [POINTER(c_long)]
gmtime.restype = POINTER(pytm)
tm2p = gmtime(byref(t1))
tm2 = tm2p.contents
showdatetime(tm2)

gmtime = libc.localtime
gmtime.argtypes = [POINTER(c_long)]
gmtime.restype = POINTER(pytm)
tm2p = gmtime(byref(t1))
tm2 = tm2p.contents
showdatetime(tm2)
