"""Define interpreter to test the printenv command"""

import argparse

from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.merge.convergence.delegate.branch.delegate.printenv.interpret import print_environment

PARSER = argparse.ArgumentParser(prog='printenv')

class StubReader(object):
    """Pretend to convert environment variables into a list"""
    def read(self):
        """Pretend to convert environment variables into a list"""
        return self.environment

class StubOutputter(object):
    """Pretend to print out text to the command line"""
    def output(self, text=None):
        """Pretend to print out text to the command line"""
        self.text = text

def test_print_environment(arg_list=None, testing_logger=None):
    """Test the printenv command"""
    namespace = PARSER.parse_args(args=arg_list)
    testing_logger.info('Testing printenv')

    reader = StubReader()
    reader.environment = [
        ('akey', 'avalue'),
        ('bkey', 'bvalue'),
    ]
    outputter = StubOutputter()
    print_environment(arg_list=[], reader=reader, outputter=outputter)

    expected = '\n'.join([
        ' -- Environment Definition -- ',
        'akey',
        '    --->avalue<---',
        'bkey',
        '    --->bvalue<---',
    ])
    same = (outputter.text == expected)
    if not same:
        testing_logger.error('Incorrect output')
        testing_logger.error('Obsereved:\n' + outputter.text)
        testing_logger.error('Expected:\n' + expected)
    testing_logger.info('Testing complete')
    return same

class Interpreter(object):
    """Interpreter to test the printenv command"""
    def interpret(self, arg_list=None):
        """Test the printenv render function"""
        success = test_print_environment(
            arg_list=arg_list,
            testing_logger=self.testing_logger
        )
        print('--- success ---' if success else '=== FAILURE ===')

def make_module_plugin():
    format_string = 'MERGE4U_TEST: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__ + '.testcase', fmt=format_string)

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = Interpreter()
    module_plugin.interpreter.testing_logger = logger
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

