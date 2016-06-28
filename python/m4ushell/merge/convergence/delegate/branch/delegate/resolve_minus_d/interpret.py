"""Define interpreter for the resolve_minus_d command"""

# import relevant module
import argparse
import datetime
import os

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.operation.branch.resolve_minus_d import default as rmdmod

PARSER = argparse.ArgumentParser(
    prog='resolve_minus_d',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='create a changelist for deleted revisions',
    epilog=CLI_HELP_EPILOG
)

def make_operation_space():
    """Make an operation space using objects from operation package"""
    operation_space = {}

    # Set integInfo and integBranch
    operation_space['prepare_delenv'] = rmdmod.PrepareDelEnvOperation()

    # Call p4 integ for delete revisions
    operation_space['call_p4_integ'] = rmdmod.CallIntegOperation()

    # checkout README and place into a pending cln
    operation_space['create_changelist'] = rmdmod.CreateChangelistOperation()

    # open file for edit within changelist
    operation_space['reopen'] = rmdmod.ReopenOperation()

    # list history of deleted files
    operation_space['list_history'] = rmdmod.ListDelHistoryOperation()

    return operation_space

class DirectoryChanger(object):
    """Change current directory"""
    def change(self, directory=None):
        """Change current directory"""
        os.chdir(directory)

class OperationSpaceFactory(object):
    """Make operation space using the factory function in this module"""
    def make(self):
        """Make operation space using the factory function in this module"""
        return make_operation_space()

class CBSMergeParameters(object):
    """Get values from os environment"""
    def __getitem__(self, name):
        """Get values from os environment"""
        return os.environ[name]

def resolve_minus_d(
        time=None,
        config=None,
        arg_list=None,
        cbs_merge_parameters=None,
        directory_changer=None,
        operation_space_factory=None,
        instant_feedback_logger=None
):
    """Interpreter for the perform_test command"""
    iflogger = instant_feedback_logger
    namespace = PARSER.parse_args(args=arg_list)

    iflogger.info('Resolve deleted revisions')
    iflogger.info('Start time: ' + time.strftime('%Y-%m-%d-%H-%M-%S'))

    directory = os.path.join(
        config['homedir'], 'integ', cbs_merge_parameters['branch'], 'integ')
    directory_changer.change(directory=directory)

    operation_space = operation_space_factory.make()

    # set integInfo and integBranch
    iflogger.info('Set integInfo and integBranch')
    delconfig = operation_space['prepare_delenv'].execute(
        branch=cbs_merge_parameters['branch'],
        fromBranch=cbs_merge_parameters['fromBranch'],
    )

    # call p4 integ for delete revisions
    iflogger.info('Call p4 integ for delete revisions')
    deleted_file_list = operation_space['call_p4_integ'].execute(
        delconfig=delconfig,
        fromCLN=cbs_merge_parameters['fromCLN'],
    )

    if not deleted_file_list:
        iflogger.warn('Aborting: No deletion files detected')
        return

    # create a new changelist for the files with deletion
    iflogger.info('Creating changelist for deletion')
    deletion_cln = operation_space['create_changelist'].execute(
        change_type='deletion',
        fromCLN=cbs_merge_parameters['fromCLN'],
        branch=cbs_merge_parameters['branch'],
        fromBranch=cbs_merge_parameters['fromBranch'],
        count=str(len(deleted_file_list)),
        config=config,
    )

    # add conflicted files to conflict changelist
    iflogger.info('Adding deletion files to deletion changelist')
    iflogger.info('Changelist: %s' % deletion_cln)
    for file_identifier in deleted_file_list:
        iflogger.info('Adding %s' % file_identifier)
        operation_space['reopen'].execute(
            changelist_number=deletion_cln,
            file_identifier=file_identifier,
            config=config,
        )

    # Provide file history of deleted files on both branch and fromBranch
    iflogger.info('Displaying deletion files history')
    directory = os.path.join(
        config['homedir'], 'integ', cbs_merge_parameters['branch'], 'integ')
    directory_changer.change(directory=directory)
    for file_identifier in deleted_file_list:
        iflogger.info('<<<checking file: %s>>>' % file_identifier)
        operation_space['list_history'].execute(
            file_identifier=file_identifier,
            branch=cbs_merge_parameters['branch'],
            config=config,
        )

class Interpreter(object):
    """Interpreter for the resolve_minus_d command"""
    def interpret(self, arg_list=None):
        """Execute p4 integ on the target branch"""
        resolve_minus_d(
            time=datetime.datetime.now(),
            config=self.config,
            arg_list=arg_list,
            cbs_merge_parameters=self.cbs_merge_parameters,
            directory_changer=self.directory_changer,
            operation_space_factory=self.operation_space_factory,
            instant_feedback_logger=self.instant_feedback_logger
        )

def make_module_plugin():
    format_string = 'MERGE4U: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__, fmt=format_string)

    interpreter = Interpreter()
    interpreter.cbs_merge_parameters = CBSMergeParameters()
    interpreter.directory_changer = DirectoryChanger()
    interpreter.operation_space_factory = OperationSpaceFactory()
    interpreter.instant_feedback_logger = logger

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = interpreter
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

