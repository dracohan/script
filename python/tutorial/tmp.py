#!/usr/bin/env python
import os
import tempfile
# Clean up a NamedTemporaryFile on your own
# delete=True means the file will be deleted on close
print tempfile.__file__
tmp = tempfile.NamedTemporaryFile(delete=True)
print tmp
try:
        # do stuff with temp
            tmp.write('stuff')
finally:
        tmp.close()  # deletes the file
