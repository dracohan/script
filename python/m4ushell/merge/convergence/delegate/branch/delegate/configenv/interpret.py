"""Define interpreter for the configenv command"""

import argparse
import datetime
import os

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.helper.feedback import log
from merge4u.interface.spacw import file_structure
from merge4u.lib.blindpath import interpret
from merge4u.operation.branch import environment

PARSER = argparse.ArgumentParser(
    prog='configenv',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='generate bash script to configure env for cbsMerge1',
    epilog=CLI_HELP_EPILOG
)
PARSER.add_argument('--out', required=True)
PARSER.add_argument('--branch', required=True)
PARSER.add_argument('--from-branch', required=True)
PARSER.add_argument('--from-cln', required=True)
PARSER.add_argument('--p4port', required=False)
PARSER.add_argument('--clientname', required=False)

def configenv(
        path=None,
        time=None,
        config=None,
        front_config=None,
        arg_list=None,
        script_factory=None,
        executable_factory=None,
        instant_feedback_logger=None
):
    """Command line interface adapter to configenv operation"""
    iflogger = instant_feedback_logger
    namespace = PARSER.parse_args(args=arg_list)
    username = config['username']
    p4port = namespace.p4port
    clientname = namespace.clientname
    if p4port is None:
        p4port = 'perforce.eng.vmware.com:1666'
        iflogger.info('--p4port not configured, use default: ' + p4port)
    if clientname is None:
        clientname = '%s-integ-%s-1' % (username, namespace.branch)
        iflogger.info('--clientname not configured, use default: ' + clientname)

    parameter_map = {
        'path': path,
        'username': username,
        'branch': namespace.branch,
        'clientname': clientname,
        'from_branch': namespace.from_branch,
        'from_cln': namespace.from_cln,
        'p4port': p4port,
        'current_time': time,
    }
    iflogger.info('Creating config file to setup environment')
    script = script_factory.make(
        parameter_map=parameter_map, config=front_config)
    executable_factory.make(filename=namespace.out, script=script)
    iflogger.info('Config file stored at %s' % namespace.out)

class ExecutableFactory(object):
    """Make a file with the given name and content"""
    def make(self, filename=None, script=None):
        """Make a file with the given name and content"""
        script_file = open(filename, 'w')
        script_file.write(script)
        script_file.close()

class Interpreter(object):
    """Interpreter for the printenv command"""
    def interpret(self, arg_list=None):
        """Call the printenv render function"""
        front_config = self.make_front_config(back_config=self.config)
        configenv(
            path=os.environ['PATH'],
            time=datetime.datetime.now(),
            config=self.config,
            front_config=front_config,
            arg_list=arg_list,
            script_factory=self.script_factory,
            executable_factory=self.executable_factory,
            instant_feedback_logger=self.instant_feedback_logger
        )

class ScriptFactory(object):
    """Use the operation package to generate environment config script"""
    def make(self, parameter_map=None, config=None):
        """Use the operation package to generate environment config script"""
        script = environment.create_config_script(
            parameter_map=parameter_map, config=config)
        return script

def make_module_plugin():
    format_string = 'MERGE4U: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__, fmt=format_string)

    interpreter = Interpreter()
    interpreter.script_factory = ScriptFactory()
    interpreter.executable_factory = ExecutableFactory()
    interpreter.instant_feedback_logger = logger
    interpreter.make_front_config = file_structure.make_front_config

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = interpreter
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

