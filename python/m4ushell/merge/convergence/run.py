"""Command line interface for running the convergence program"""

import sys
import os

def run():
    """Run the convergence program"""
    merge4u_parent_directory = os.environ['MERGE4U_PARENT_DIRECTORY']
    sys.path.append(merge4u_parent_directory)

    module_path = 'merge4u.merge.convergence.program'
    module = __import__(module_path, fromlist=[''])
    module.PROGRAM.run()

if __name__ == '__main__':
    run()

