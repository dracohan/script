"""Branch delegate"""

import os

from merge4u.lib.blindpath import interpret

PLUGIN = interpret.DelegatingInterpreterPlugin()
PLUGIN.path = os.path.dirname(__file__)
PLUGIN.package = __package__
PLUGIN.dependency_set = set()

