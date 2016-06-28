"""Define interpreter to test the configenv command"""

import argparse
import datetime

from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.merge.convergence.delegate.branch.delegate.resolve_minus_d.interpret import resolve_minus_d

PARSER = argparse.ArgumentParser(prog='resolve_minus_d')

class StubCreateChangelistOperation(object):
    """Pretend to create a changelist"""
    def execute(self, **kwargs):
        """Pretend to create a changelist"""
        self.history.append({
            'operation_name': 'create_changelist',
            'kwargs': kwargs,
        })
        return self.dummy_cln_value_list.pop()

class StubPrepareDelEnvOperation(object):
    """Pretend to setup dash d integration"""
    def execute(self, **kwargs):
        """Pretend to setup dash d integration"""
        self.history.append({
            'operation_name': 'prepare_delenv',
            'kwargs': kwargs,
        })
        return self.dummy_integ_branch_value

class StubCallIntegOperation(object):
    """Pretend to do an integration"""
    def execute(self, **kwargs):
        """Pretend to do an integration"""
        self.history.append({
            'operation_name': 'call_p4_integ',
            'kwargs': kwargs,
        })
        return self.dummy_deletion_list_value

class StubReopenOperation(object):
    """Pretend to reopen a file for editing"""
    def execute(self, **kwargs):
        """Pretend to reopen a file for editing"""
        self.history.append({
            'operation_name': 'reopen',
            'kwargs': kwargs,
        })

class StubHistoryListerOperation(object):
    """Pretend to print the revision history of a file"""
    def execute(self, **kwargs):
        """Pretend to print the revision history of a file"""
        self.history.append({
            'operation_name': 'list_history',
            'kwargs': kwargs,
        })

class StubDirectoryChanger(object):
    """Pretend to change the working directory"""
    def change(self, directory=None):
        """Pretend to change the working directory"""
        self.directory = directory

class StubOperationSpaceFactory(object):
    """Create a stub operation space"""
    def make(self):
        """Create a stub operation space"""
        return self.stub_operation_space

def test_resolve_minus_d(arg_list=None, testing_logger=None):
    """Test the configenv command"""
    namespace = PARSER.parse_args(args=arg_list)
    testing_logger.info('Testing resolve minus d')

    record_list = []
    injected_logger = log.make_record_keeping_logger(
        name=__name__ + '.testsubject', record_list=record_list)

    stub_directory_changer = StubDirectoryChanger()
    stub_operation_space = {
        'prepare_delenv': StubPrepareDelEnvOperation(),
        'call_p4_integ': StubCallIntegOperation(),
        'create_changelist': StubCreateChangelistOperation(),
        'list_history': StubHistoryListerOperation(),
        'reopen': StubReopenOperation(),
    }
    observed_history = []
    for key in list(stub_operation_space):
        stub_operation_space[key].history = observed_history
    stub_operation_space['call_p4_integ'].dummy_deletion_list_value = [
        'dummy-deletion-1-value',
        'dummy-deletion-2-value',
        'dummy-deletion-3-value',
    ]
    stub_operation_space['create_changelist'].dummy_cln_value_list = [
        'dummy-deletion-cln-value',
    ]
    stub_operation_space['prepare_delenv'].dummy_integ_branch_value = (
        'dummy-delconfig-value')

    operation_space_factory = StubOperationSpaceFactory()
    operation_space_factory.stub_operation_space = stub_operation_space

    stub_config = {
        'homedir': 'dummy-homedir-value',
    }
    resolve_minus_d(
        time=datetime.datetime.now(),
        config=stub_config,
        arg_list=[],
        cbs_merge_parameters={
            'fromCLN': 'dummy-from-cln-value',
            'branch': 'dummy-branch-value',
            'fromBranch': 'dummy-from-branch-value',
        },
        directory_changer=stub_directory_changer,
        operation_space_factory=operation_space_factory,
        instant_feedback_logger=injected_logger
    )

    expected_history = [
        {
            'operation_name': 'prepare_delenv',
            'kwargs': {
                'branch': 'dummy-branch-value',
                'fromBranch': 'dummy-from-branch-value',
            },
        },
        {
            'operation_name': 'call_p4_integ',
            'kwargs': {
                'delconfig': 'dummy-delconfig-value',
                'fromCLN': 'dummy-from-cln-value',
            },
        },
        {
            'operation_name': 'create_changelist',
            'kwargs': {
                'change_type': 'deletion',
                'fromCLN': 'dummy-from-cln-value',
                'branch': 'dummy-branch-value',
                'fromBranch': 'dummy-from-branch-value',
                'count': '3',
                'config': stub_config,
            },
        },
        {
            'operation_name': 'reopen',
            'kwargs': {
                'changelist_number': 'dummy-deletion-cln-value',
                'file_identifier': 'dummy-deletion-1-value',
                'config': stub_config,
            },
        },
        {
            'operation_name': 'reopen',
            'kwargs': {
                'changelist_number': 'dummy-deletion-cln-value',
                'file_identifier': 'dummy-deletion-2-value',
                'config': stub_config,
            },
        },
        {
            'operation_name': 'reopen',
            'kwargs': {
                'changelist_number': 'dummy-deletion-cln-value',
                'file_identifier': 'dummy-deletion-3-value',
                'config': stub_config,
            },
        },
        {
            'operation_name': 'list_history',
            'kwargs': {
                'file_identifier': 'dummy-deletion-1-value',
                'branch': 'dummy-branch-value',
                'config': stub_config,
            },
        },
        {
            'operation_name': 'list_history',
            'kwargs': {
                'file_identifier': 'dummy-deletion-2-value',
                'branch': 'dummy-branch-value',
                'config': stub_config,
            },
        },
        {
            'operation_name': 'list_history',
            'kwargs': {
                'file_identifier': 'dummy-deletion-3-value',
                'branch': 'dummy-branch-value',
                'config': stub_config,
            },
        },
    ]
    operation_passed = True
    if len(expected_history) != len(observed_history):
        operation_passed = False
        testing_logger.error('Number of operations does not match')
    for expected, observed in zip(expected_history, observed_history):
        if not compare_history_element(expected=expected, observed=observed):
            operation_passed = False
            testing_logger.error('Observed operation doesnt match expected')
            testing_logger.error(str(observed))
            testing_logger.error(str(expected))

    # TODO test accuracy of message logger here

    directory = 'dummy-homedir-value/integ/dummy-branch-value/integ'
    dir_passed = (stub_directory_changer.directory == directory)
    if not dir_passed:
        testing_logger.error('Used wrong working directory')
        testing_logger.error('Observed: ' + stub_directory_changer.directory)
        testing_logger.error('Expected: ' + directory)

    complete_success = operation_passed and dir_passed
    testing_logger.info('Testing completed')
    return complete_success

def compare_history_element(expected=None, observed=None):
    """Compare the an executed operation with what is expected"""
    result = expected['operation_name'] == observed['operation_name']
    for key in list(expected['kwargs']):
        result = result and (expected['kwargs'][key] == observed['kwargs'][key])
    return result

class Interpreter(object):
    """Interpreter to test the resolve_minus_d command"""
    def interpret(self, arg_list=None):
        """Test the resolve_minus_d function"""
        success = test_resolve_minus_d(
            arg_list=arg_list,
            testing_logger=self.testing_logger
        )
        print('--- success ---' if success else '=== FAILURE ===')

def make_module_plugin():
    format_string = 'MERGE4U_TEST: %(levelname)s: %(message)s'
    stream_logger = log.make_instant_feedback_logger(
        name=__name__ + '.testcase', fmt=format_string)

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = Interpreter()
    module_plugin.interpreter.testing_logger = stream_logger
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

