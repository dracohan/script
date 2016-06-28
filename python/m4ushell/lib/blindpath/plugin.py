"""Define plugin classes"""

import os

class PluginLoader(object):
    """Load plugins in their specified order"""
    def load(self, container_path=None, container_package=None, context=None):
        """Load plugins from a directory that is also a python package"""
        plugin_module_list = self.get_plugin_module_list(
            container_path=container_path,
        )
        plugin_list = self.get_plugin_list(
            plugin_module_list=plugin_module_list,
            container_package=container_package
        )
        sequencer = make_dependency_sequencer()
        plugin_map = self.process_plugin_list(
            plugin_list=plugin_list,
            sequencer=sequencer
        )
        return self.import_plugin_graph(
            sequencer=sequencer,
            plugin_map=plugin_map,
            context=context
        )

    def get_plugin_module_list(self, container_path=None):
        """Get a list of module names from a directory in the container"""
        plugin_module_list = []
        enable_directory = os.path.join(container_path, 'enable')
        for item in os.listdir(enable_directory):
            enable_path = os.path.join(enable_directory, item)
            enable_file = open(enable_path)
            plugin_module = enable_file.read(999).strip()
            enable_file.close()
            plugin_module_list.append(plugin_module)
        return plugin_module_list

    def get_plugin_list(self, plugin_module_list=None, container_package=None):
        """Get a list of plugin objects from a list of module names"""
        plugin_list = []
        for plugin_module in plugin_module_list:
            absolute_plugin_module = container_package + '.' + plugin_module
            module = __import__(absolute_plugin_module, fromlist=[''])
            plugin_list.append((plugin_module, module.PLUGIN))
        return plugin_list

    def process_plugin_list(self, plugin_list=None, sequencer=None):
        """Make a map of module name to plugin and register dependencies"""
        plugin_map = {}
        for name, plugin in plugin_list:
            if hasattr(plugin, 'get_ordering_name'):
                name = plugin.get_ordering_name()
            sequencer.mark_pending(name=name)
            plugin_map[name] = plugin

            dependency_set = set()
            if hasattr(plugin, 'get_dependency_set'):
                dependency_set = plugin.get_dependency_set()
            for depender, dependee in dependency_set:
                sequencer.add_dependency(name=depender, dependency=dependee)
        return plugin_map

    def import_plugin_graph(
            self,
            sequencer=None,
            plugin_map=None,
            context=None
    ):
        """Load plugins in an order that obeys the dependency graph"""
        name = sequencer.get_next()
        # I got 99 problems but an infinite loop aint one
        for dontcare in range(99):
            if name is None:
                break
            if name not in plugin_map:
                sequencer.clear(name=name)
                name = sequencer.get_next()
                continue
            plugin = plugin_map[name]
            context = plugin.load(context=context)
            sequencer.mark_satisfied(name)
            name = sequencer.get_next()
        return context

class DependencySequencer(object):
    """Describe a dependency graph and find satisfied dependencies"""
    def get_next(self):
        """Return a name which has no unsatisfied dependencies"""
        name = None
        try_set = self.pending_set.copy()
        while try_set:
            if name in try_set:
                try_set.remove(name)
            else:
                name = try_set.pop()
            dependency_set = self.dependency_map.get(name, set())
            for dependency in dependency_set:
                if dependency not in self.satisfied_set:
                    name = dependency
                    break
            else:
                # all dependencies are satisfied
                return name

    def mark_satisfied(self, name=None):
        """Mark a named dependency as satisfied"""
        if name in self.pending_set:
            self.pending_set.remove(name)
        self.satisfied_set.add(name)

    def mark_pending(self, name=None):
        """Mark a named dependency as pending"""
        if name in self.satisfied_set:
            self.satisfied_set.remove(name)
        self.pending_set.add(name)

    def clear(self, name=None):
        """Remove any status for a named dependency"""
        if name in self.pending_set:
            self.pending_set.remove(name)
        if name in self.satisfied_set:
            self.satisfied_set.remove(name)

    def add_dependency(self, name=None, dependency=None):
        """Add a dependency relation of name onto dependency"""
        if name not in self.dependency_map:
            self.dependency_map[name] = set()
        dependency_set = self.dependency_map[name].add(dependency)

    def has_dependency(self, name=None, dependency=None):
        """Check for a dependency relation of name onto dependency"""
        if name not in self.dependency_map:
            return False
        dependency_set = self.dependency_map[name]
        return dependency in dependency_set

    def remove_dependency(self, name=None, dependency=None):
        """Remove a dependency relation of name onto dependency"""
        if self.has_dependency(name=name, dependency=dependency):
            self.dependency_map[name].remove(dependency)
        if not self.dependency_map[name]:
            self.dependency_map.pop(name)

def make_dependency_sequencer():
    """Factory function to make a dependency sequencer"""
    result = DependencySequencer()
    result.satisfied_set = set()
    result.pending_set = set()
    result.dependency_map = {}
    return result

