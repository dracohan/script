"""Define interpreter for the cbsMerge1 command"""

import argparse
import os
import shlex
import subprocess
import time

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.lib.blindpath import interpret

PARSER = argparse.ArgumentParser(
    prog='cbsMerge1',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='call cbsMerge1 with required parameters',
    epilog=CLI_HELP_EPILOG
)

class Interpreter(object):
    """Interpreter for the cbsMerge1 command"""
    def interpret(self, arg_list=None):
        """Call the create cbsMerge1 function"""
        namespace = PARSER.parse_args(args=arg_list)

        branch = os.environ['branch']
        config = self.config
        homedir = config['homedir']
        os.chdir(os.path.join(homedir, 'integ', branch, 'integ'))
        cbs_log = open("cbsMerge1_" + time.strftime("%Y%m%d_%H%M%S"), 'w')
        cmd = "cbsMerge1 " +  os.environ['partialArg'] + \
              " -c " + os.environ['P4CLIENT'] + " -It" + \
              " -l " + os.environ['logdir'] + " " + \
              os.environ['fromBranch'] + " " + \
              os.environ['branch'] + " @" + os.environ['fromCLN']
        cbs_merge1_process = subprocess.Popen(
            shlex.split(cmd),
            stdout=cbs_log,
            stdin=subprocess.PIPE
        )
        cbs_merge1_process.communicate("exit 1")
        cbs_log.close()

PLUGIN = interpret.ConcreteInterpreterPlugin()
PLUGIN.interpreter = Interpreter()
PLUGIN.dependency_set = set()

