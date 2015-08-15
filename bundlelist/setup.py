from distutils.core import setup
import py2exe


py2exe_opciones = {'py2exe': {"includes":["sip", "PyQt4"]}}
script = [{"script":"bundlelist.py"}]

setup(windows=script,options=py2exe_opciones)
