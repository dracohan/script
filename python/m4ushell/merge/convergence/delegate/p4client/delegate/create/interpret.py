"""Define interpreter for the create command"""

import argparse
import subprocess
import shlex
import os

from merge4u.constant import CLI_HELP_EPILOG, P4PORT_NAME_MAP
from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret

PARSER = argparse.ArgumentParser(
    prog='create',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='create a perforce client from template branch client',
    epilog=CLI_HELP_EPILOG
)
PARSER.add_argument('--clientname', help='p4 client name', required=True)
PARSER.add_argument('--p4port', help='p4 port example: domain:port or (' + (
    ', '.join(list(P4PORT_NAME_MAP)) + ')'))
PARSER.add_argument(
    '--branch',
    help='branch that new client created on',
    required=True
)

class ConfigFactory(object):
    """Create a perforce config file"""
    def make(self, filename=None, parameter_map=None):
        """Create a perforce config file"""
        config_file = open(filename, 'w')
        for key in list(parameter_map):
            config_file.write('%s=%s\n' % (key, parameter_map[key]))
        config_file.close()

class ClientCloner(object):
    """Clone a perforce client from an existing template client"""
    def clone(self, branch_name=None, client_name=None):
        """Clone a perforce client from an existing template client"""
        out_command = "p4 client -o -t m4u-{bn} {cn}".format(
            bn=branch_name, cn=client_name)
        in_command = "p4 client -i"
        iflogger.info('p4 cmd: ' + out_command + ' | ' + in_command)
        out_process = subprocess.Popen(
            shlex.split(out_command),
            stdout=subprocess.PIPE
        )
        in_process = subprocess.Popen(
            shlex.split(in_command),
            stdin=out_process.stdout,
            stdout=subprocess.PIPE
        )
        out_process.stdout.close()
        output = in_process.communicate()[0]
        iflogger.info('Cloning output:\n' + output)

def create(
        p4conf_filename=None,
        config=None,
        arg_list=None,
        config_factory=None,
        client_cloner=None,
        instant_feedback_logger=None
):
    """Create a perforce client using a branch name and client name"""
    iflogger = instant_feedback_logger
    namespace = PARSER.parse_args(args=arg_list)

    # TODO trying to find a p4port. might need a better way of doing this.
    p4port = config.get('P4PORT')
    if namespace.p4port:
        p4port = namespace.p4port
    if not p4port:
        p4port = P4PORT_NAME_MAP.get('prod', 'NoDefaultPortFound')
        iflogger.info('Using the default p4port: ' + p4port)
    p4port = P4PORT_NAME_MAP.get(p4port, p4port)

    parameter_map = {
        'P4USER': config['username'],
        'P4PORT': p4port,
        'P4CLIENT': namespace.clientname,
    }
    config_factory.make(filename=p4conf_filename, parameter_map=parameter_map)
    client_cloner.clone(
        user=parameter_map['P4USER'],
        branch_name=namespace.branch,
        client_name=namespace.clientname
    )

class Interpreter(object):
    """Interpreter for the create command"""
    def interpret(self, arg_list=None):
        """Call the create p4client function"""
        create(
            p4conf_filename=os.environ['P4CONFIG'],
            config=self.config,
            arg_list=arg_list,
            config_factory=self.config_factory,
            client_cloner=self.client_cloner
        )

def make_module_plugin():
    format_string = 'MERGE4U: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__, fmt=format_string)

    interpreter = Interpreter()
    interpreter.config_factory = ConfigFactory()
    interpreter.client_cloner = ClientCloner()
    interpreter.instant_feedback_logger = logger

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = interpreter
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

