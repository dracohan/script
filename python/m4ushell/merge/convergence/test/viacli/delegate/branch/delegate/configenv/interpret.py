"""Define interpreter to test the configenv command"""

import argparse

from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.merge.convergence.delegate.branch.delegate.configenv.interpret import configenv

PARSER = argparse.ArgumentParser(prog='configenv')

class StubScriptFactory(object):
    """Pretend to create the contents of a bash script"""
    def make(self, parameter_map=None):
        """Pretend to create the contents of a bash script"""
        self.parameter_map = parameter_map
        return self.dummy_script

class StubExecutableFactory(object):
    """Pretend to write the contents of a script to a file"""
    def make(self, filename=None, script=None):
        """Pretend to write the contents of a script to a file"""
        self.filename = filename
        self.script = script

def test_config_environment(arg_list=None, testing_logger=None):
    """Test the configenv command"""
    namespace = PARSER.parse_args(args=arg_list)
    testing_logger.info('Testing configenv')

    record_list = []
    injected_logger = log.make_record_keeping_logger(
        name=__name__ + '.testsubject', record_list=record_list)

    script_factory = StubScriptFactory()
    script_factory.dummy_script = 'dummy-script-value'
    executable_factory = StubExecutableFactory()
    configenv(
        path='dummy-path-value',
        time='dummy-time-value',
        config={
            'username': 'dummy-username-value',
            'homedir': 'dummy-homedir-value',
        },
        arg_list=[
            '--out', 'dummy-filename-value',
            '--branch', 'dummy-branch-value',
            '--clientname', 'dummy-clientname-value',
            '--from-branch', 'dummy-from-branch-value',
            '--from-cln', 'dummy-from-cln-value',
        ],
        script_factory=script_factory,
        executable_factory=executable_factory,
        instant_feedback_logger=injected_logger
    )

    dummy_parameter_map = {
        'path': 'dummy-path-value',
        'username': 'dummy-username-value',
        'homedir': 'dummy-homedir-value',
        'branch': 'dummy-branch-value',
        'clientname': 'dummy-clientname-value',
        'from_branch': 'dummy-from-branch-value',
        'from_cln': 'dummy-from-cln-value',
        'current_time': 'dummy-time-value',
    }
    filename_passed = (executable_factory.filename == 'dummy-filename-value')
    if not filename_passed:
        testing_logger.error('Created executable with wrong filename')
        testing_logger.error('Observed: ' + executable_factory.filename)
        testing_logger.error('Expected: ' + 'dummy-filename-value')
    script_passed = (executable_factory.script == 'dummy-script-value')
    if not script_passed:
        testing_logger.error('Created script with wrong content')
        testing_logger.error('Observed: ' + executable_factory.script)
        testing_logger.error('Expected: ' + 'dummy-script-value')
    args_passed = True
    parameter_map = script_factory.parameter_map
    for key in list(dummy_parameter_map):
        if key not in parameter_map:
            args_passed = False
            testing_logger.error('Key %s not in parameter map' % key)
            continue
        if dummy_parameter_map[key] != parameter_map[key]:
            args_passed = False
            value = parameter_map[key]
            testing_logger.error('Key %s has wrong value %s' % (key, value))
            testing_logger.error('Expected: %s' % dummy_parameter_map[key])
    complete_success = filename_passed and script_passed and args_passed
    testing_logger.info('Testing complete')
    return complete_success

class Interpreter(object):
    """Interpreter to test the configenv command"""
    def interpret(self, arg_list=None):
        """Test the configenv render function"""
        success = test_config_environment(
            arg_list=arg_list,
            testing_logger=self.testing_logger
        )
        print('--- success ---' if success else '=== FAILURE ===')

def make_module_plugin():
    format_string = 'MERGE4U_TEST: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__ + '.testcase', fmt=format_string)

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = Interpreter()
    module_plugin.interpreter.testing_logger = logger
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

