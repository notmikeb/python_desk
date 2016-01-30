#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ctypes
from ctypes import *

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

tm1 = pytm()
print( 'asctime is ',  c_char_p(libc.asctime(byref(tm1))).value)
libc.mktime(byref(tm1))
print( tm1.tm_sec, tm1.tm_year)

