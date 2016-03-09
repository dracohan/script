import os
print(os.getenv('PATH'))
os.environ['myenv']='abc'
print(os.environ['myenv'])