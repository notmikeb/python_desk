import py2exe
import PyQt4.QtCore
import PyQt4.QtGui
import PyQt4
from distutils.core import setup
import glob
from distutils.core import setup

DATA=[('imageformats',glob.glob(r'C:\Python34\Lib\site-packages\PyQt4\plugins\imageformats\*.dll')), ('images', glob.glob(r'*.jpg'))]

py2exe_opciones = {'py2exe': {"includes":["sip", "PyQt4.QtCore"], "bundle_files":1, 'compressed':True}}
script = [{"script":"bundlelist.py"}]

setup(windows=script,options=py2exe_opciones, zipfile = None,  data_files = DATA)