"""Define interpreter to test the setup workspace command"""

import argparse
import os

from merge4u.constant import BRANCH_LIST
from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.merge.convergence.delegate.branch.delegate.setup_workspace.interpret import setup_workspace

PARSER = argparse.ArgumentParser(prog='setup_workspace')

class StubWorkspaceInitializer(object):
    """Pretend to create directories"""
    def initialize(self, directory_list=None):
        """Pretend to create directories"""
        self.directory_list = directory_list

def test_setup_workspace(arg_list=None, testing_logger=None):
    """Test the setup workspace command"""
    namespace = PARSER.parse_args(args=arg_list)
    testing_logger.info('Testing setup workspace')

    initializer = StubWorkspaceInitializer()
    setup_workspace(
        config={
            'homedir': 'dummy-homedir-value',
        },
        arg_list=[],
        initializer=initializer
    )

    expected_directory_list = []
    for branch in BRANCH_LIST:
        temp = os.path.join('dummy-homedir-value', 'integ', branch, 'integ')
        expected_directory_list.append(temp)

    directory_list = initializer.directory_list
    directory_list_passed = (directory_list == expected_directory_list)
    if not directory_list_passed:
        testing_logger.error('Incorrect directory list')
        testing_logger.error('Obsereved:\n' + str(directory_list))
        testing_logger.error('Expected:\n' + str(expected_directory_list))
    testing_logger.info('Testing complete')
    return directory_list_passed

class Interpreter(object):
    """Interpreter to test the setup workspace command"""
    def interpret(self, arg_list=None):
        """Test the setup workspace function"""
        success = test_setup_workspace(
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

