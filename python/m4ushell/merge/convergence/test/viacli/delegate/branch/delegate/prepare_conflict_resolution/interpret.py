"""Define interpreter to test the configenv command"""

import argparse
import datetime

from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.merge.convergence.delegate.branch.delegate.prepare_conflict_resolution.interpret import prepare_conflict_resolution

PARSER = argparse.ArgumentParser(prog='prepare_conflict_resolution')

class StubListUnresolvedOperation(object):
    """Pretend to list local files that are unresolved with perforce"""
    def execute(self, **kwargs):
        """Pretend to list local files that are unresolved with perforce"""
        self.history.append({
            'operation_name': 'list_unresolved',
            'kwargs': kwargs,
        })
        return self.dummy_unresolved_list_value

class StubCheckHasFilesOpenedOperation(object):
    """Pretend to check for open files"""
    def execute(self, **kwargs):
        """Pretend to check for open files"""
        self.history.append({
            'operation_name': 'check_has_files_opened',
            'kwargs': kwargs,
        })
        return True

class StubCreateChangelistOperation(object):
    """Pretend to create perforce changelist"""
    def execute(self, **kwargs):
        """Pretend to create perforce changelist"""
        self.history.append({
            'operation_name': 'create_changelist',
            'kwargs': kwargs,
        })
        return self.dummy_cln_value_list.pop()

class StubRetrievePendingChangelistOperation(object):
    """Pretend to retrieve pending changelist"""
    def execute(self, **kwargs):
        """Pretend to retrieve pending changelist"""
        self.history.append({
            'operation_name': 'retrieve_pending_changelist',
            'kwargs': kwargs,
        })
        return self.dummy_pending_changelist_value

class StubResolveSavingConflictOperation(object):
    """Pretend to resolve conflicts"""
    def execute(self, **kwargs):
        """Pretend to resolve conflicts"""
        self.history.append({
            'operation_name': 'resolve_saving_conflict',
            'kwargs': kwargs,
        })

class StubEditOperation(object):
    """Pretend to do a perforce edit"""
    def execute(self, **kwargs):
        """Pretend to do a perforce edit"""
        self.history.append({
            'operation_name': 'edit',
            'kwargs': kwargs,
        })

class StubReopenOperation(object):
    """Pretend to do a perforce reopen"""
    def execute(self, **kwargs):
        """Pretend to do a perforce reopen"""
        self.history.append({
            'operation_name': 'reopen',
            'kwargs': kwargs,
        })

class StubOperationSpaceFactory(object):
    """Return a stub operation space"""
    def make(self):
        """Return a stub operation space"""
        return self.stub_operation_space

class StubPlugin(object):
    """Pretend to initialize a target"""
    def initialize(self, target=None):
        """Pretend to initialize a target"""
        self.target = target

class StubPluginLoader(object):
    """Pretend to load a plugin"""
    def load(self, plugin_path=None):
        """Pretend to load a plugin"""
        self.plugin_path = plugin_path
        return self.stub_plugin

def test_prepare_conflict_resolution(arg_list=None, testing_logger=None):
    """Test the configenv command"""
    namespace = PARSER.parse_args(args=arg_list)
    testing_logger.info('Testing prepare conflict resolution')

    record_list = []
    injected_logger = log.make_record_keeping_logger(
        name=__name__ + '.testsubject', record_list=record_list)

    plugin_loader = StubPluginLoader()
    stub_plugin = StubPlugin()
    plugin_loader.stub_plugin = stub_plugin

    stub_operation_space = {
        'tracker_tag': 'dummy-tracker-tag-value',
        'list_unresolved': StubListUnresolvedOperation(),
        'check_has_files_opened': StubCheckHasFilesOpenedOperation(),
        'create_changelist': StubCreateChangelistOperation(),
        'retrieve_pending_changelist': StubRetrievePendingChangelistOperation(),
        'resolve_saving_conflict': StubResolveSavingConflictOperation(),
        'edit': StubEditOperation(),
        'reopen': StubReopenOperation(),
    }
    observed_history = []
    for key in list(stub_operation_space):
        if key == 'tracker_tag':
            continue
        stub_operation_space[key].history = observed_history
    stub_operation_space['list_unresolved'].dummy_unresolved_list_value = [
        'dummy-conflict-1-value',
        'dummy-conflict-2-value',
        'dummy-conflict-3-value',
    ]
    stub_operation_space['create_changelist'].dummy_cln_value_list = [
        'dummy-conflict-cln-value',
    ]
    stub_operation_space[
        'retrieve_pending_changelist'].dummy_pending_changelist_value = (
            'dummy-conflict-free-cln-value')
    operation_space_factory = StubOperationSpaceFactory()
    operation_space_factory.stub_operation_space = stub_operation_space

    prepare_conflict_resolution(
        time=datetime.datetime.now(),
        config='dummy-config-value',
        arg_list=[
            '--client', 'dummy-client-value',
            '--plugin', 'dummy-plugin-value',
        ],
        cbs_merge_parameters={
            'fromCLN': 'dummy-from-cln-value',
            'branch': 'dummy-branch-value',
            'fromBranch': 'dummy-from-branch-value',
        },
        operation_space_factory=operation_space_factory,
        plugin_loader=plugin_loader,
        instant_feedback_logger=injected_logger
    )

    plugin_passed = (stub_plugin.target['tracker_tag'] == (
        'dummy-tracker-tag-value'))
    if not plugin_passed:
        testing_logger.error('Plugin not used')

    expected_history = [
        {
            'operation_name': 'retrieve_pending_changelist',
            'kwargs': {
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
        {
            'operation_name': 'list_unresolved',
            'kwargs': {
                'changelist_number': 'dummy-conflict-free-cln-value',
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
        {
            'operation_name': 'create_changelist',
            'kwargs': {
                'change_type': 'conflict',
                'fromCLN': 'dummy-from-cln-value',
                'branch': 'dummy-branch-value',
                'fromBranch': 'dummy-from-branch-value',
                'count': '3',
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
        {
            'operation_name': 'reopen',
            'kwargs': {
                'changelist_number': 'dummy-conflict-cln-value',
                'file_identifier': 'dummy-conflict-1-value',
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
        {
            'operation_name': 'reopen',
            'kwargs': {
                'changelist_number': 'dummy-conflict-cln-value',
                'file_identifier': 'dummy-conflict-2-value',
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
        {
            'operation_name': 'reopen',
            'kwargs': {
                'changelist_number': 'dummy-conflict-cln-value',
                'file_identifier': 'dummy-conflict-3-value',
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
        {
            'operation_name': 'check_has_files_opened',
            'kwargs': {
                'changelist_number': 'dummy-conflict-free-cln-value',
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
        {
            'operation_name': 'resolve_saving_conflict',
            'kwargs': {
                'changelist_number': 'dummy-conflict-cln-value',
                'config': 'dummy-config-value',
                'parameter_map': {'client': 'dummy-client-value'},
            },
        },
    ]
    testing_logger.info('Testing observed operations')
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

    complete_success = operation_passed and plugin_passed
    testing_logger.info('Testing completed')
    return complete_success

def compare_history_element(expected=None, observed=None):
    """Compare operation history"""
    result = expected['operation_name'] == observed['operation_name']
    for key in list(expected['kwargs']):
        result = result and (expected['kwargs'][key] == observed['kwargs'][key])
    return result

class Interpreter(object):
    """Interpreter to test the prepare_conflict_resolution command"""
    def interpret(self, arg_list=None):
        """Test the prepare_conflict_resolution function"""
        success = test_prepare_conflict_resolution(
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

