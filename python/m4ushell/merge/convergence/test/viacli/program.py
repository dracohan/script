"""Initialize the viacli test program and run it"""

import os
import sys

from merge4u.lib.blindpath import interpret
from merge4u.lib.blindpath import plugin

class Program(object):
    """Adapter for the interface expected by the external script"""
    def run(self):
        """Initialize the viacli test program"""
        context = {
            'plugin_loader': plugin.PluginLoader(),
            'config': None, # might need to actually have a test config later
        }

        interpreter_plugin = interpret.DelegatingInterpreterPlugin()
        interpreter_plugin.path = os.path.dirname(__file__)
        interpreter_plugin.package = __package__

        interpreter = interpreter_plugin.load(context=context)
        interpreter.interpret(arg_list=sys.argv[1:])

PROGRAM = Program()

