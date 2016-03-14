import os

top = '/home/bwhan/test/todelete'
for root, dirs, files in os.walk(top, topdown=False):
    for name in files:
        print 'deleting file: ', os.path.join(root, name)
        os.remove(os.path.join(root,name))
    for name in dirs:
        print 'remove dir: ', os.path.join(root, name)
        os.rmdir(os.path.join(root,name))
