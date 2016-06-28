"""Define interpreter for the summary command"""

import argparse

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.lib.blindpath import interpret

PARSER = argparse.ArgumentParser(
    prog='sumamry',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='print out a summary of the local merge activity',
    epilog=CLI_HELP_EPILOG
)

def summary(config=None, arg_list=None):
    """Command line interface adapter to summary operation"""
    namespace = PARSER.parse_args(args=arg_list)

    print('=== merge summary ===')

    print('--- cbsMerge1 results ---')
    # TODO print data here gathered from output file

    print('--- prepare conflict resolution results ---')
    # TODO print data here gathered from output file

    print('--- resolve delete revisions results ---')
    # TODO print data here gathered from output file

class Interpreter(object):
    """Interpreter for the printenv command"""
    def interpret(self, arg_list=None):
        """Call the summary function"""
        summary(config=self.config, arg_list=arg_list)

PLUGIN = interpret.ConcreteInterpreterPlugin()
PLUGIN.interpreter = Interpreter()
PLUGIN.dependency_set = set()

