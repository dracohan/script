"""Define interpreter for the printenv command"""

import argparse

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.lib.blindpath import interpret
import merge4u.operation.branch.environment

PARSER = argparse.ArgumentParser(
    prog='printenv',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='print out the env used by the cbsMerge1 script',
    epilog=CLI_HELP_EPILOG
)

def print_environment(arg_list=None, reader=None, outputter=None):
    """Render the environment defined in the operation package to the shell"""
    namespace = PARSER.parse_args(args=arg_list)

    env = reader.read()
    output = [' -- Environment Definition -- ']
    for name, value in env:
        output.extend(['\n', name, '\n    --->', value, '<---'])
    outputter.output(text=''.join(output))

class Interpreter(object):
    """Interpreter for the printenv command"""
    def interpret(self, arg_list=None):
        """Call the printenv render function"""
        print_environment(
            arg_list=arg_list,
            reader=self.reader,
            outputter=self.outputter
        )

class EnvironmentReader(object):
    """Read environment variables using operation module"""
    def read(self):
        """Read environment variables using operation module"""
        return merge4u.operation.branch.environment.read()

class TextOutputter(object):
    """Print text to stdout"""
    def output(self, text=None):
        """Print text to stdout"""
        print(text)

PLUGIN = interpret.ConcreteInterpreterPlugin()
PLUGIN.interpreter = Interpreter()
PLUGIN.interpreter.reader = EnvironmentReader()
PLUGIN.interpreter.outputter = TextOutputter()
PLUGIN.dependency_set = set()

