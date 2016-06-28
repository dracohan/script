"""Define interpreter for the prepare_conflict_resolution command"""

import argparse
import datetime
import os

from merge4u.constant import CLI_HELP_EPILOG
from merge4u.helper.feedback import log
from merge4u.lib.blindpath import interpret
from merge4u.operation.branch.perform_test import default as ptmod

PARSER = argparse.ArgumentParser(
    prog='perform_test',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='do sandbox builds and run svs tests',
    epilog=CLI_HELP_EPILOG
)

PARSER.add_argument('--branch')
PARSER.add_argument('--logdir')
PARSER.add_argument(
    '--testtype',
    default='all',
    choices=['sb', 'svs', 'all']
)

def make_operation_space():
    """Make an operation space using objects from operation package"""
    operation_space = {}

    # checkout README and place into a pending cln
    operation_space['checkout_readme'] = ptmod.CheckOutREADME()

    # launch svs test
    operation_space['launch_svs'] = ptmod.LaunchSVS()

    # revert README file
    operation_space['revert_all'] = ptmod.RevertAll()

    #delete a specific cln
    operation_space['delete_cln'] = ptmod.DeleteCLN()

    #get tot cln
    operation_space['get_tot_cln'] = ptmod.GetTOTCLN()

    #launch sandbox test
    operation_space['launch_sandbox'] = ptmod.LaunchSandbox()

    return operation_space

def perform_test(config=None, arg_list=None, instant_feedback_logger=None):
    """Interpreter for the perform_test command"""
    iflogger = instant_feedback_logger
    namespace = PARSER.parse_args(args=arg_list)

    iflogger.info('Perform test')
    pt_start_time = datetime.datetime.now()
    iflogger.info('Start time: ' + pt_start_time.strftime('%Y-%m-%d-%H-%M-%S'))

    branch = os.environ['branch']
    logdir = os.environ['logdir']

    if namespace.branch:
        branch = namespace.branch
    if namespace.logdir:
        logdir = namespace.logdir
    iflogger.info('Branch: ' + branch)
    iflogger.info('Logdir: ' + logdir)

    #change working directory for following perforce actions
    os.chdir(config['homedir'] + '/integ/' + branch + '/integ')

    operation_space = make_operation_space()

    if namespace.testtype in ['svs', 'all']:
        #check out README file
        iflogger.info('Checkout README file with new changelist')
        changelist_number = operation_space['checkout_readme'].execute(
            branch=branch
        )

        #launch svs
        iflogger.info('Launch svs test with new created chagnelist')
        operation_space['launch_svs'].execute(
            changelist_number=changelist_number,
            branch=branch,
            logdir=logdir
        )

        #revert README file
        iflogger.info('Revert README file in the changelist')
        operation_space['revert_all'].execute(
            changelist_number=changelist_number
        )

        #delete the change list
        iflogger.info('Delete the empty changelist')
        operation_space['delete_cln'].execute(
            changelist_number=changelist_number
        )

    if namespace.testtype in ['sb', 'all']:
        #get the totCLN
        iflogger.info('Get the TOT cln')
        tot_cln = operation_space['get_tot_cln'].execute()

        #launch sandbox
        iflogger.info('Launch sandbox test with TOT cln')
        operation_space['launch_sandbox'].execute(
            tot_cln=tot_cln,
            branch=branch,
            logdir=logdir
        )

class Interpreter(object):
    """Call the perform_test function"""
    def interpret(self, arg_list=None):
        """Call the perform_test function"""
        perform_test(
            config=self.config,
            arg_list=arg_list,
            instant_feedback_logger=self.instant_feedback_logger
        )

PLUGIN = interpret.ConcreteInterpreterPlugin()
PLUGIN.interpreter = Interpreter()
PLUGIN.interpreter.instant_feedback_logger = log.make_instant_feedback_logger(
    name=__name__, fmt='MERGE4U: %(levelname)s: %(message)s')
PLUGIN.dependency_set = set()

