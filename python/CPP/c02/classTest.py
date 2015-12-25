#This is a class test script that on master branch

class FooClass(object):
    """my very first class: FooClass"""
    version = 0.1
    def __init__(self, nm='Baowei Han'):
        """constructor"""
        self.name = nm
        print 'Create a class instant for', nm
    def showname(self):
        """display instance attribute and class name"""
        print 'Your name is', self.name
        print 'My name is', self.__class__.__name__
    def showVer(self):
        """display class static attribute"""
        print self.version
    def addMe2Me(self,x):
        """apply + operation to argument"""
        return x + x

fool = FooClass()
fool.showname()
fool.showVer()
print fool.addMe2Me("Xyz")
