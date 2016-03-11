#!/usr/bin/env python

import os

def callfrommain():
    print("call from main")
    print '__file__ is: ',  __file__
    print '__package__ is: ',  __package__

#thisismain
if __name__ == '__main__':
    callfrommain()
