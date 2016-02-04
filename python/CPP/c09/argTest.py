import sys
import stat
import os
print 'you entered', len(sys.argv),'arguments...'
print 'they were:', str(sys.argv)
print(os.getcwd())
print(os.listdir(os.getcwd()))
os.chmod('/mnt/hgfs/code/script/python/CPP/c09/file1', stat.S_IRUSR+stat.S_IWUSR)