"""Define the plugin for the sync command"""

import argparse
import os

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.helper.feedback import log
from merge4u.interface.spacw import file_structure
from merge4u.lib.blindpath import interpret
from merge4u.operation.branch import perforce

PARSER = argparse.ArgumentParser(
    prog='sync',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='sync the specified branch in the merge home directory',
    epilog=CLI_HELP_EPILOG
)
PARSER.add_argument('--branch', required=True)
PARSER.add_argument('--cln', required=False)

class DirectoryChanger(object):
    """Change current directory"""
    def change(self, directory=None):
        """Change current directory"""
        os.chdir(directory)

class DirectoryCleaner(object):
    """Delete all visible files inside directory"""
    def cleanup(self, directory=None):
        """Delete all visible files inside directory"""
        os.system('rm -rf %s/*' % directory)

def sync(
        config=None,
        branch_config=None,
        arg_list=None,
        directory_cleaner=None,
        directory_changer=None,
        repo_syncer=None,
        instant_feedback_logger=None
):
    """Sync perforce code to your client specified by the branch"""
    iflogger = instant_feedback_logger
    namespace = PARSER.parse_args(args=arg_list)
    directory = branch_config[namespace.branch]
    iflogger.info('Changing working directory')
    directory_changer.change(directory=directory)
    iflogger.info('Clearing directory: %s' % directory)
    directory_cleaner.cleanup(directory=directory)
    # if namespace.cln is None
    #     p4 sync will use the top of trunk
    # this has the same effect as using the cln from perforce.get_tot_cln()
    iflogger.info('Syncing from perforce')
    repo_syncer.sync(force=True, quiet=True, cln=namespace.cln)
    iflogger.info('Sync completed')

class Interpreter(object):
    """Interpreter for the sync command"""
    def interpret(self, arg_list=None):
        """Execute a p4 sync in the branch working directory"""
        front_config = self.make_front_config(back_config=self.config)
        branch_config = self.make_branch_config(front_config=front_config)
        sync(
            config=self.config,
            branch_config=branch_config,
            arg_list=arg_list,
            directory_cleaner=self.directory_cleaner,
            directory_changer=self.directory_changer,
            repo_syncer=self.repo_syncer,
            instant_feedback_logger=self.instant_feedback_logger
        )

class RepoSyncer(object):
    """Do a p4 sync"""
    def sync(self, force=None, cln=None, quiet=None):
        """Do a p4 sync"""
        perforce.sync(force=force, cln=cln, quiet=quiet)

def make_module_plugin():
    format_string = 'MERGE4U: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__, fmt=format_string)

    interpreter = Interpreter()
    interpreter.directory_cleaner = DirectoryCleaner()
    interpreter.directory_changer = DirectoryChanger()
    interpreter.repo_syncer = RepoSyncer()
    interpreter.instant_feedback_logger = logger
    interpreter.make_front_config = file_structure.make_front_config
    interpreter.make_branch_config = file_structure.make_branch_config

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = interpreter
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

