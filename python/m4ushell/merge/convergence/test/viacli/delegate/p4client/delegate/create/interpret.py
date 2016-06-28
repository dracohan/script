"""Define interpreter to test the create command"""

import argparse

from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.merge.convergence.delegate.p4client.delegate.create.interpret import create

PARSER = argparse.ArgumentParser(prog='create')

class StubConfigFactory(object):
    """Pretends to write configuration params to a file"""
    def make(self, filename=None, parameter_map=None):
        """Pretends to write configuration params to a file"""
        self.parameter_map = parameter_map

class StubClientCloner(object):
    """Pretends to clone a perforce client"""
    def clone(self, user=None, branch_name=None, client_name=None):
        """Pretends to clone a perforce client"""
        self.user = user
        self.branch_name = branch_name
        self.client_name = client_name

def test_create(arg_list=None, testing_logger=None):
    """Test the create command"""
    namespace = PARSER.parse_args(args=arg_list)
    testing_logger.info('Testing create')

    record_list = []
    injected_logger = log.make_record_keeping_logger(
        name=__name__ + '.testsubject', record_list=record_list)

    config_factory = StubConfigFactory()
    client_cloner = StubClientCloner()
    create(
        p4conf_filename='dummy-filename-value',
        config={
            'username': 'dummy-username-value',
            'P4PORT': 'dummy-p4port-value',
        },
        arg_list=[
            '--clientname', 'dummy-clientname-value',
            '--branch', 'dummy-branch-value',
        ],
        config_factory=config_factory,
        client_cloner=client_cloner,
        instant_feedback_logger=injected_logger
    )

    expected_parameter_map = {
        'P4CLIENT': 'dummy-clientname-value',
        'P4USER': 'dummy-username-value',
        'P4PORT': 'dummy-p4port-value',
    }
    user_passed = (client_cloner.user == 'dummy-username-value')
    branch_passed = (client_cloner.branch_name == 'dummy-branch-value')
    clientname_passed = (client_cloner.client_name == 'dummy-clientname-value')
    if not (user_passed and branch_passed and clientname_passed):
         testing_logger.error('Client cloner called with wrong arguments')
    config_passed = True
    parameter_map = config_factory.parameter_map
    for key in list(expected_parameter_map):
        temp = (expected_parameter_map[key] == parameter_map[key])
        config_passed = config_passed and temp
    if not config_passed:
        testing_logger.error('Created config file with wrong parameters')
    complete_success = config_passed and (
        user_passed and branch_passed and clientname_passed)
    testing_logger.info('Testing complete')
    return complete_success

class Interpreter(object):
    """Interpreter to test the configenv command"""
    def interpret(self, arg_list=None):
        """Test the configenv render function"""
        success = test_create(
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

