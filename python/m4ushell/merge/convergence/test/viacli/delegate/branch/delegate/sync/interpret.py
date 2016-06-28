"""Define interpreter to test the sync command"""

import argparse
import os

from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.merge.convergence.delegate.branch.delegate.sync.interpret import sync

PARSER = argparse.ArgumentParser(prog='sync')

class StubRepoSyncer(object):
    """Pretend to do a perforce sync"""
    def sync(self, **kwargs):
        """Pretend to do a perforce sync"""
        self.kwargs = kwargs

class StubDirectoryChanger(object):
    """Pretend to change the working directory"""
    def change(self, directory=None):
        """Pretend to change the working directory"""
        self.directory = directory

class StubDirectoryCleaner(object):
    """Pretend to cleanup a directory"""
    def cleanup(self, directory=None):
        """Pretend to cleanup a directory"""
        self.directory = directory

def test_sync(arg_list=None, testing_logger=None):
    """Test the configenv command"""
    namespace = PARSER.parse_args(args=arg_list)
    testing_logger.info('Testing sync')

    record_list = []
    injected_logger = log.make_record_keeping_logger(
        name=__name__ + '.testsubject', record_list=record_list)

    directory_cleaner = StubDirectoryCleaner()
    directory_changer = StubDirectoryChanger()
    repo_syncer = StubRepoSyncer()
    sync(
        config={
            'homedir': 'dummy-homedir-value',
        },
        arg_list=[
            '--branch', 'dummy-branch-value',
            '--cln', 'dummy-cln-value',
        ],
        directory_changer=directory_changer,
        directory_cleaner=directory_cleaner,
        repo_syncer=repo_syncer,
        instant_feedback_logger=injected_logger
    )

    directory = os.path.join(
        'dummy-homedir-value', 'integ', 'dummy-branch-value', 'integ')
    directory_passed = (directory_changer.directory == directory)
    if not directory_passed:
        testing_logger.error('Changer called with wrong kwargs')
        testing_logger.error('Observed: ' + directory_changer.directory)
        testing_logger.error('Expected: ' + directory)
    cleaner_passed = (directory_cleaner.directory == directory)
    if not cleaner_passed:
        testing_logger.error('Cleaner called with wrong kwargs')
        testing_logger.error('Observed: ' + directory_cleaner.directory)
        testing_logger.error('Expected: ' + directory)
    expected_syncer_kwargs = {
        'force': True,
        'quiet': True,
        'cln': 'dummy-cln-value',
    }
    repo_passed = (repo_syncer.kwargs == expected_syncer_kwargs)
    if not repo_passed:
        testing_logger.error('Repo syncer called with wrong kwargs')
        testing_logger.error('Observed: ' + str(repo_syncer.kwargs))
        testing_logger.error('Expected: ' + str(expected_syncer_kwargs))
    complete_success = directory_passed and cleaner_passed and repo_passed
    testing_logger.info('Testing complete')
    return complete_success

class Interpreter(object):
    """Interpreter to test the sync command"""
    def interpret(self, arg_list=None):
        """Test the sync function"""
        success = test_sync(
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

