#!/usr/bin/env python
# Filename: using_sys.py
# diff -sl test

import sys

#their change

print 'The command line arguments are:'
for i in sys.argv:
	print i

#their add

print '\n\nThe PYTHONPATH is',sys.path,'\n'

