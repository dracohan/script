"""Define the plugin for the sync bmps config command"""

import argparse
import os
import subprocess

from merge4u.constant import CLI_HELP_EPILOG, P4PORT_NAME_MAP, BRANCH_LIST
from merge4u.helper.feedback import log
from merge4u.interface.spacw import file_structure
from merge4u.lib.blindpath import interpret
from merge4u.operation.branch import perforce

PARSER = argparse.ArgumentParser(
    prog='sync_bmps_config',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='sync bmps config files in the merge home directory',
    epilog=CLI_HELP_EPILOG
)

class DirectoryCleaner(object):
    """Delete all visible files inside directory"""
    def cleanup(self, directory=None):
        """Delete all visible files inside directory"""
        os.system('rm -rf %s/*' % directory)

def make_client_spec(clientname=None, username=None, root=None):
    """Generate a clientspec from clientname, username, and root"""
    line_list = [
        '# A Perforce Client Specification.',
        '#',
        '#  Client:      The client name.',
        '#  Update:      The date this specification was last modified.',
        '#  Access:      The date this client was last used in any way.',
        '#  Owner:       The Perforce user name of the user who owns the client',
        '#               workspace. The default is the user who created the',
        '#               client workspace.',
        '#  Host:        If set, restricts access to the named host.',
        '#  Description: A short description of the client (optional).',
        '#  Root:        The base directory of the client workspace.',
        '#  AltRoots:    Up to two alternate client workspace roots.',
        '#  Options:     Client options:',
        '#                      [no]allwrite [no]clobber [no]compress',
        '#                      [un]locked [no]modtime [no]rmdir',
        '#  SubmitOptions:',
        '#                      submitunchanged/submitunchanged+reopen',
        '#                      revertunchanged/revertunchanged+reopen',
        '#                      leaveunchanged/leaveunchanged+reopen',
        '#  LineEnd:     Text file line endings on client: local/unix/mac/win/share.',
        '#  ServerID:    If set, restricts access to the named server.',
        '#  View:        Lines to map depot files into the client workspace.',
        '#  ChangeView:  Lines to restrict depot files to specific changelists.',
        "#  Stream:      The stream to which this client's view will be dedicated.",
        '#               (Files in stream paths can be submitted only by dedicated',
        '#               stream clients.) When this optional field is set, the',
        '#               View field will be automatically replaced by a stream',
        '#               view as the client spec is saved.',
        '#  StreamAtChange:  A changelist number that sets a back-in-time view of a',
        '#                   stream ( Stream field is required ).',
        '#                   Changes cannot be submitted when this field is set.',
        '#',
        "# Use 'p4 help client' to see more about client views and options.",
        '',
        'Client:\t{cn}',
        '',
        'Owner:\t{username}',
        '',
        'Description:',
        '\tCreated by {username}.',
        '',
        'Root:{root}\t',
        '',
        'Options:\tnoallwrite noclobber nocompress unlocked nomodtime normdir',
        '',
        'SubmitOptions:\tsubmitunchanged',
        '',
        'LineEnd:\tlocal',
        '',
        'View:',
    ]
    for branch in BRANCH_LIST:
        line_list.append('\t//depot/bmps-config/main/p4/perforce_1666/depot/bora/{bn}/branch.json //{cn}/perforce_1666/depot/bora/{bn}/branch.json'.format(cn=clientname, bn=branch))
        line_list.append('\t//depot/bmps-config/main/p4/perforce-qa_1666/depot/testware/{bn}/branch.json //{cn}/perforce-qa_1666/depot/testware/{bn}/branch.json'.format(cn=clientname, bn=branch))
        line_list.append('\t//depot/bmps-config/main/p4/perforce-qa_1666/depot/odtf/{bn}/branch.json //{cn}/perforce-qa_1666/depot/odtf/{bn}/branch.json'.format(cn=clientname, bn=branch))

    content = '\n'.join(line_list).format(
        username=username, cn=clientname, bn='main', root=root)
    return content

def find_free_perforce_clientname(port=None, username=None):
    """Find free perforce clientname"""
    arg_list = ['p4', '-p', port, 'clients', '-u', username]
    list_client_process = subprocess.Popen(arg_list, stdout=subprocess.PIPE)
    p4_clients_output = list_client_process.communicate()[0]
    for i in range(9999):
        clientname = username + '-releng-bmps-config-' + str(i)
        if clientname not in p4_clients_output:
            break
    return clientname

class BMPSConfigEnsurer(object):
    def ensure(self, username=None, directory=None, logger=None):
        logger.info('Checking to see if directory for bmps config exists')
        if not os.path.exists(directory):
            logger.info('Making directory for bmps config')
            os.makedirs(directory)
            logger.info('Making perforce config file')
            releng = P4PORT_NAME_MAP['releng']
            clientname = find_free_perforce_clientname(
                port=releng,
                username=username
            )
            p4config_path = os.path.join(directory, '.p4config')
            p4config_file = open(p4config_path, 'w')
            p4config_file.write('P4PORT=%s\n' % releng)
            p4config_file.write('P4USER=%s\n' % username)
            p4config_file.write('P4CLIENT=%s' % clientname)
            p4config_file.close()
            logger.info('Checking to see if you are logged in to perforce')
            if not perforce.is_logged_in(
                port=releng, user=username, quiet=True):
                logger.info('Logging in to perforce, enter password')
                login_good = perforce.log_in(
                    port=releng, user=username, quiet=True)
                if not login_good:
                    logger.error('Login Failed. Cleanup required.')
                    return
                logger.info('Thanks %s . Login succeeded' % username)
            logger.info('Making perforce client for bmps config')
            clientspec = make_client_spec(
                clientname=clientname, username=username, root=directory)
            logger.info('Spec Begin\n\n%s\n\nSpec End' % clientspec)
            p4_client_process = subprocess.Popen(
                ['p4', '-q', '-p', releng, '-u', username, 'client', '-i'],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE
            )
            output = p4_client_process.communicate(input=clientspec)[0]

def sync(
        config=None,
        front_config=None,
        arg_list=None,
        directory_cleaner=None,
        directory_changer=None,
        repo_syncer=None,
        bmps_config_ensurer=None,
        instant_feedback_logger=None
):
    """Sync perforce code to your client specified by the branch"""
    iflogger = instant_feedback_logger
    namespace = PARSER.parse_args(args=arg_list)
    directory = front_config['bmps_config_root']
    iflogger.info('Ensuring that the bmps config is up to date')
    bmps_config_ensurer.ensure(
        username=config['username'],
        directory=directory,
        logger=instant_feedback_logger
    )
    clientname = None
    p4config_path = os.path.join(directory, '.p4config')
    for p4config_line in open(p4config_path).read().split('\n'):
        temp_name, temp_value = p4config_line.split('=', 1)
        if temp_name == 'P4CLIENT':
            clientname = temp_value
    iflogger.info('Clearing directory: %s' % directory)
    directory_cleaner.cleanup(directory=directory)
    iflogger.info('Syncing from perforce')
    releng = P4PORT_NAME_MAP['releng']
    repo_syncer.sync(port=releng, clientname=clientname, force=True, quiet=True)
    iflogger.info('Sync completed')

class Interpreter(object):
    """Interpreter for the sync command"""
    def interpret(self, arg_list=None):
        """Execute a p4 sync in the branch working directory"""
        front_config = self.make_front_config(back_config=self.config)
        sync(
            config=self.config,
            front_config=front_config,
            arg_list=arg_list,
            directory_cleaner=self.directory_cleaner,
            repo_syncer=self.repo_syncer,
            bmps_config_ensurer=self.bmps_config_ensurer,
            instant_feedback_logger=self.instant_feedback_logger
        )

class RepoSyncer(object):
    """Do a p4 sync"""
    def sync(self, *args, **kwargs):
        """Do a p4 sync"""
        perforce.sync(*args, **kwargs)

def make_module_plugin():
    format_string = 'MERGE4U: %(levelname)s: %(message)s'
    logger = log.make_instant_feedback_logger(
        name=__name__, fmt=format_string)

    interpreter = Interpreter()
    interpreter.directory_cleaner = DirectoryCleaner()
    interpreter.repo_syncer = RepoSyncer()
    interpreter.bmps_config_ensurer = BMPSConfigEnsurer()
    interpreter.instant_feedback_logger = logger
    interpreter.make_front_config = file_structure.make_front_config

    module_plugin = interpret.ConcreteInterpreterPlugin()
    module_plugin.interpreter = interpreter
    module_plugin.dependency_set = set()
    return module_plugin

PLUGIN = make_module_plugin()

