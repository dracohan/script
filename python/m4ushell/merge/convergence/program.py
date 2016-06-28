"""Initialize the convergence program and run it"""

import json
import logging
import os
import sys

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.lib.blindpath import interpret
from merge4u.lib.blindpath import plugin

def get_config(path):
    """Load json data from the file with the specified path"""
    config_file = open(path)
    config = json.load(config_file)
    config_file.close()
    # TODO remove this after refactoring all code to not use homedir as key
    config['home_dir'] = config['homedir']
    return config

class Program(object):
    """Adapter for the interface expected by the external script"""
    def run(self):
        """Initialize the convergence program"""
        config = get_config(os.environ['MERGE4U_SHELL_CONFIG'])
        context = {
            'plugin_loader': plugin.PluginLoader(),
            'config': config,
        }

        interpreter_plugin = interpret.DelegatingInterpreterPlugin()
        interpreter_plugin.path = os.path.dirname(__file__)
        interpreter_plugin.package = __package__

        interpreter = interpreter_plugin.load(context=context)
        try:
            interpreter.interpret(arg_list=sys.argv[1:])
        except Exception: # catch everything. no exceptions.
            message = 'An error has occurred. Please contact development.'
            message += '\n\n' + CLI_HELP_EPILOG + '\n\n'
            logging.exception(message)
            print('')

PROGRAM = Program()

