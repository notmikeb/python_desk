#!/usr/bin/env python
# -*- coding: utf-8 -*
from distutils.core import setup, Extension

module1 = Extension('helloworld', sources = ['hellomodule.c'])

setup (name = 'PackageName',
       version = '1.0',
       description = 'This is a demo package',
       ext_modules = [module1])
