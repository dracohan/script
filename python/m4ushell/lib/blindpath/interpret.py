"""Define interpreter interface classes"""

import os

class DelegatingInterpreter(object):
    """Load a plugin directory and delegate interpreting"""
    def interpret(self, arg_list=None):
        """Load a plugin directory and delegate interpreting"""
        plugin_name, new_arg_list = arg_list[0], arg_list[1:]
        interpreter = self.plugin_loader.load(
            container_path=os.path.join(self.path, 'delegate', plugin_name),
            container_package='.'.join([self.package, 'delegate', plugin_name]),
            context=self.context
        )
        interpreter.interpret(arg_list=new_arg_list)

class DelegatingInterpreterPlugin(object):
    """Template for a delegating interpreter plugin"""
    def get_dependency_set(self):
        """Get dependency relations between plugins"""
        return self.dependency_set

    def load(self, context=None):
        """Load an interpreter"""
        interpreter = DelegatingInterpreter()
        interpreter.path = self.path
        interpreter.package = self.package
        interpreter.context = context
        interpreter.plugin_loader = context['plugin_loader']
        return interpreter

class ConcreteInterpreterPlugin(object):
    """Template for a concrete interpreter plugin"""
    def get_dependency_set(self):
        """Get dependency relations between plugins"""
        return self.dependency_set

    def load(self, context=None):
        """Load the interpreter"""
        self.interpreter.config = context['config']
        return self.interpreter

