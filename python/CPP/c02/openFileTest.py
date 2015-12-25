#open and file test with exception handled
try:
    filename = raw_input('Enter file name:')
    fobj = open(filename, 'r')
    for eachline in fobj:
        print eachline,
    fobj.close()
except IOError, e:
    print 'file open error', e, 'end'