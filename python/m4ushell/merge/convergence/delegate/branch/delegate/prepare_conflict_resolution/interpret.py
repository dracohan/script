"""Define interpreter for the prepare_conflict_resolution command"""

import argparse
import datetime
import os

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.operation.branch.prepare_conflict_resolution \
    import default as pcrmod

PARSER = argparse.ArgumentParser(
    prog='prepare_conflict_resolution',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='create pending changelists after cbsMerge1 is run',
    epilog=CLI_HELP_EPILOG
)
PARSER.add_argument('--plugin', required=False)
PARSER.add_argument('--client', required=False)
# TODO might need some of these: --out --branch --from-branch --from-cln

def make_operation_space():
    """Create proxy objects that execute commands"""
    operation_space = {}

    # find the files that have unresolved conflicts
    operation_space['list_unresolved'] = pcrmod.ListUnresolvedOperation()

    # check if a changelist has files opened
    operation_space['check_has_files_opened'] = (
        pcrmod.CheckHasFilesOpenedOperation())

    # create a new changelist
    operation_space['create_changelist'] = pcrmod.CreateChangelistOperation()

    #retrieve current pending changelist
    operation_space['retrieve_pending_changelist'] = pcrmod.RetrievePendingChangelistOperation()

    # save the conflicts
    operation_space['resolve_saving_conflict'] = (
        pcrmod.ResolveSavingConflictOperation())

    # Reopen file to changelist
    operation_space['reopen'] = pcrmod.ReopenOperation()

    return operation_space

class OperationSpaceFactory(object):
    """Make an operation space using this modules factory function"""
    def make(self):
        """Make an operation space using this modules factory function"""
        return make_operation_space()

class PluginLoader(object):
    """Import a plugin module and return its plugin"""
    def load(self, plugin_path=None):
        """Import a plugin module and return its plugin"""
        plugin_module = __import__(plugin_path, fromlist=[''])
        return plugin_module.PLUGIN

class CBSMergeParameters(object):
    """Return values from the os environment"""
    def __getitem__(self, name):
        """Return values from the os environment"""
        return os.environ[name]

def prepare_conflict_resolution(
        time=None,
        config=None,
        arg_list=None,
        cbs_merge_parameters=None,
        operation_space_factory=None,
        plugin_loader=None,
        instant_feedback_logger=None
):
    """Command line interface adapter to the conflict operation"""
    iflogger = instant_feedback_logger
    namespace = PARSER.parse_args(args=arg_list)

    iflogger.info('Prepare conflict resolution')
    iflogger.info('Start time: ' + time.strftime('%Y-%m-%d-%H-%M-%S'))

    # creating the operation space
    operation_space = operation_space_factory.make()
    plugin = None
    if namespace.plugin is not None:
        iflogger.info('Loading operation plugin')
        plugin = plugin_loader.load(plugin_path=namespace.plugin)
    if plugin is not None:
        iflogger.info('Plugin initializing operation space')
        plugin.initialize(target=operation_space)

    parameter_map = {
        'client': namespace.client,
    }

    # Retrieve the pending changelist number generated by cbsMerge1
    iflogger.info('Retrieve the pending changelist')
    conflict_free_cln = operation_space['retrieve_pending_changelist'].execute(
        config=config,
        parameter_map=parameter_map
    )

    if not conflict_free_cln:
        iflogger.warn('Aborting: No conflict free changelist found')
        return

    # find the files that have unresolved conflicts
    iflogger.info('Finding the files that have unresolved conflicts')
    original_unresolved_file_list = operation_space['list_unresolved'].execute(
        changelist_number=conflict_free_cln,
        config=config,
        parameter_map=parameter_map
    )

    # TODO might want to force handling a no conflict situation
    if not original_unresolved_file_list:
        iflogger.warn('Aborting: No conflicts detected')
        return

    # create a new changelist for the files with conflicts
    iflogger.info('Creating changelist for conflicts')
    conflict_cln = operation_space['create_changelist'].execute(
        change_type='conflict',
        fromCLN=cbs_merge_parameters['fromCLN'],
        branch=cbs_merge_parameters['branch'],
        fromBranch=cbs_merge_parameters['fromBranch'],
        count=str(len(original_unresolved_file_list)),
        config=config,
        parameter_map=parameter_map
    )

    if not conflict_cln:
        iflogger.warn('Aborting: No conflict changelist created')
        return

    # add conflicted files to conflict changelist
    iflogger.info('Adding conflicted files to conflict changelist')
    iflogger.info('Changelist: %s' % conflict_cln)
    for file_identifier in original_unresolved_file_list:
        iflogger.info('Reopening %s' % file_identifier)
        operation_space['reopen'].execute(
            changelist_number=conflict_cln,
            file_identifier=file_identifier,
            config=config,
            parameter_map=parameter_map
        )

    # check changelist for opened files
    iflogger.info('Checking changelist for open files')
    has_conflict_free_files = operation_space['check_has_files_opened'].execute(
        changelist_number=conflict_free_cln,
        config=config,
        parameter_map=parameter_map
    )

    if not has_conflict_free_files:
        iflogger.warn('Aborting: All files have conflicts')
        return

    # save the conflicts
    iflogger.info('Saving the conflicts')
    operation_space['resolve_saving_conflict'].execute(
        changelist_number=conflict_cln,
        config=config,
        parameter_map=parameter_map
    )

class Interpreter(object):
    """Interpreter for the printenv command"""
    def interpret(self, arg_list=None):
        """Call the prepare_conflict_resolution render function"""
        prepare_conflict_resolution(
            time=datetime.datetime.now(),
            config=self.config,
            arg_list=arg_list,
            cbs_merge_parameters=self.cbs_merge_parameters,
            operation_space_factory=self.operation_space_factory,
            plugin_loader=self.plugin_loader,
            instant_feedback_logger=self.instant_feedback_logger
        )

def make_module_plugin():
    format_string = 'MERGE4U: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__, fmt=format_string)

    interpreter = Interpreter()
    interpreter.cbs_merge_parameters = CBSMergeParameters()
    interpreter.operation_space_factory = OperationSpaceFactory()
    interpreter.plugin_loader = PluginLoader()
    interpreter.instant_feedback_logger = logger

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = interpreter
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()
