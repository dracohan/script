"""Define interpreter for the setup_workspace command"""

import argparse
import os

from merge4u.constant import CLI_HELP_EPILOG, BRANCH_LIST
from merge4u.interface.spacw import file_structure
from merge4u.lib.blindpath import interpret

PARSER = argparse.ArgumentParser(
    prog='setup_workspace',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='create the directory structure expected by merge4u',
    epilog=CLI_HELP_EPILOG
)

def setup_workspace(
        config=None,
        front_config=None,
        branch_config=None,
        arg_list=None,
        initializer=None
):
    """initialize the directories that merge4u expects"""
    namespace = PARSER.parse_args(args=arg_list)
    branch_list = BRANCH_LIST
    directory_list = [branch_config[branch] for branch in branch_list]
    directory_list.append(front_config['log_top_dir'])
    initializer.initialize(directory_list=directory_list)

def b2d(homedir, branch):
    """Convert a branchname into a directory path"""
    return os.path.join(homedir, 'integ', branch, 'integ')

class Interpreter(object):
    """Interpreter for the setup_workspace command"""
    def interpret(self, arg_list=None):
        """Call the setup_workspace function"""
        front_config = self.make_front_config(back_config=self.config)
        branch_config = self.make_branch_config(front_config=front_config)
        setup_workspace(
            config=self.config,
            front_config=front_config,
            branch_config=branch_config,
            arg_list=arg_list,
            initializer=self.initializer,
        )

class WorkspaceInitializer(object):
    """Create a directory for each path in the list"""
    def initialize(self, directory_list=None):
        """Create a directory for each path in the list"""
        for directory in directory_list:
            if not os.path.exists(directory):
                os.makedirs(directory)

PLUGIN = interpret.ConcreteInterpreterPlugin()
PLUGIN.interpreter = Interpreter()
PLUGIN.interpreter.initializer = WorkspaceInitializer()
PLUGIN.interpreter.make_front_config = file_structure.make_front_config
PLUGIN.interpreter.make_branch_config = file_structure.make_branch_config
PLUGIN.dependency_set = set()

