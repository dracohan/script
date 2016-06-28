"""Install the merge4u tool completely and in a standard way"""

import json
import os
import subprocess
import sys

def run():
    """Generate the install scripts"""
    working_dir = os.getcwd()

    # gather user input
    config_data = gather_config_data()
    username = config_data['username']

    # write merge4u json config file
    config_json = generate_config_json(config=config_data)
    json_file = open('config.json', 'w')
    json_file.write(config_json)
    json_file.close()

    # write merge4u prop config file
    config_prop = generate_config_prop(config=config_data)
    prop_file = open('config.prop', 'w')
    prop_file.write(config_prop)
    prop_file.close()

    # write p4config file without P4CLIENT
    p4config_data = generate_p4config_data(username=username)
    p4config_prop = generate_config_prop(config=p4config_data)
    p4config_file = open(os.environ.get('P4CONFIG', '.p4config'), 'w')
    p4config_file.write(p4config_prop)
    p4config_file.close()

    # ensure perforce is logged in
    is_logged_in = perforce_is_logged_in()
    if not is_logged_in:
        perforce_log_in()

    # get all the clients for this user
    p4_clients_output = perforce_clients_output(username=username)

    # find a free clientname
    for i in range(9999):
        clientname = username + '-releng-merge4u-' + str(i)
        if clientname not in p4_clients_output:
            break

    # write p4config file with P4CLIENT
    p4config_data = generate_p4config_data(
        username=username,
        clientname=clientname
    )
    p4config_prop = generate_config_prop(config=p4config_data)
    p4config_file = open(os.environ.get('P4CONFIG', '.p4config'), 'w')
    p4config_file.write(p4config_prop)
    p4config_file.close()

    # make a perforce client and sync it
    perforce_client_root = working_dir
    clientspec = make_perforce_client_spec(
        clientname=clientname,
        username=username,
        root=perforce_client_root
    )
    make_perforce_client(username=username, clientspec=clientspec)
    perforce_sync()

    # make a virtual environment and a dependency install script
    virtualenv_wheel_url = (
        'https://build-artifactory.eng.vmware.com/artifactory/'
        'pypi-remote-cache/bb/83/'
        '1aa921ab8c7d017e4098582acbc422a30485f820290577b361c8fc407d53/'
        'virtualenv-15.0.1-py2.py3-none-any.whl'
    )
    virtualenv_wheel_path = os.path.join(
        working_dir, 'virtualenv-15.0.1-py2.py3-none-any.whl')
    virtualenv_src_path = os.path.join(working_dir, 'virtualenv_15_0_1')
    virtualenv_module = os.path.join(virtualenv_src_path, 'virtualenv.py')
    wget(url=virtualenv_wheel_url, path=virtualenv_wheel_path)
    if not os.path.isfile(virtualenv_wheel_path):
        sys.stderr.write('A required file was not found on your file system:')
        sys.stderr.write('\n' + virtualenv_wheel_path + '\n')
        return
    unzip(archive_path=virtualenv_wheel_path, src_path=virtualenv_src_path)

    python_executable = (
        '/build/toolchain/lin64/python-2.7.9-openssl1.0.1s/bin/python'
    )
    if not os.path.isfile(python_executable):
        sys.stderr.write('A required file was not found on your file system:')
        sys.stderr.write('\n' + python_executable + '\n')
        return

    venvname = 'venvmerge4u'
    make_virtual_environment(
        name=venvname,
        module=virtualenv_module,
        python_executable=python_executable
    )

    install_deps_script = os.path.abspath('install_deps.bash')
    make_dependency_install_script(
        name=install_deps_script,
        dep_list=[
            'https://build-artifactory.eng.vmware.com/artifactory/'
            'pypi-remote-cache/py2.py3/s/six/six-1.10.0-py2.py3-none-any.whl',
        ],
        venv=venvname
    )

    # make setup script
    setup_script_name = os.path.abspath('setup_merge4u.bash')
    # src_path = '' # use production directory
    src_path = 'merge4u_fallback' # use fallback directory
    make_setup_script(
        filename=setup_script_name,
        install_path=working_dir,
        src_path=src_path,
        venvname=venvname
    )

    # generate an alias to setup merge4u
    setup_alias = generate_merge4u_setup_alias(filename=setup_script_name)

    # append an alias to call the setup script to bashrc
    append_setup_call_to_bashrc(alias=setup_alias)

    # make file to run setup script
    setup_script_sourcer = os.path.abspath('setup_script_sourcer.bash')
    make_alias_invoking_script(
        filename=setup_script_sourcer,
        install_deps_script_name=install_deps_script,
        setup_alias=setup_alias,
        setup_script_name=setup_script_name
    )

    # return file name
    return setup_script_sourcer

def devnull():
    """Return a file that writes to dev null"""
    return open('/dev/null', 'w')

def gather_config_data():
    """Get config data from user"""
    sys.stderr.write('\nEnter your perforce username: ')
    username = raw_input()
    sys.stderr.write('Thanks ' + username + '!\n')
    return {
        'username': username,
        'homedir': os.path.expanduser('~/m4u'),
        'summarydir': 'm4u_merge_summary',
        'P4PORT': 'w3-perforce16.eng.vmware.com:1942',
        'merge_top_dir': 'integ/cbsmerge/integ',
    }

def generate_p4config_data(username=None, clientname=None):
    """Generate the contents of a p4config file"""
    config = {
        'P4USER': username,
        'P4PORT': 'perforce-releng.eng.vmware.com:1850',
    }
    if clientname:
        config['P4CLIENT'] = clientname
    return config

def generate_config_json(config=None):
    """Generate the contents for a merge4u json config"""
    return json.dumps(config, indent=4) + '\n'

def generate_config_prop(config=None):
    """Generate the contents for a merge4u prop config"""
    item_list = [(name, config[name]) for name in list(config)]
    return '\n'.join([name + '=' + value for name, value in item_list]) + '\n'

def perforce_is_logged_in():
    """Check if user is logged into perforce"""
    return not subprocess.call(['p4', 'login', '-s'], stdout=devnull())

def perforce_log_in():
    """Log user into perforce"""
    return not subprocess.call(['p4', 'login'], stdout=devnull())

def perforce_clients_output(username=None):
    """List all of a users clients"""
    arg_list = ['p4', 'clients', '-u', username]
    list_client_process = subprocess.Popen(arg_list, stdout=subprocess.PIPE)
    return list_client_process.communicate()[0]

def make_perforce_client_spec(clientname=None, username=None, root=None):
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
        'Client:\t' + clientname,
        '',
        'Owner:\t' + username,
        '',
        'Description:',
        '\tCreated by ' + username + '.',
        '',
        'Root:\t' + root,
        '',
        'Options:\tnoallwrite noclobber nocompress unlocked nomodtime normdir',
        '',
        'SubmitOptions:\tsubmitunchanged',
        '',
        'LineEnd:\tlocal',
        '',
        'View:',
        '\t//depot/bms/main/src/merge4u_fallback/... ' + (
            '//' + clientname + '/merge4u_fallback/...'),
        # '\t//depot/bms/main/src/merge4u/... //' + clientname + '/merge4u/...',
        '',
        '',
    ]
    return '\n'.join(line_list)

def make_perforce_client(username=None, clientspec=None):
    """Make a perforce client using a clientspec"""
    p4_client_process = subprocess.Popen(
        ['p4', 'client', '-i'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE
    )
    p4_client_process.communicate(input=clientspec)

def perforce_sync():
    """Sync a perforce client"""
    return subprocess.call(['p4', 'sync'], stdout=devnull())

def wget(url=None, path=None):
    """Download a file using wget"""
    command = ['wget', url, '-O', path]
    return subprocess.call(command, stdout=devnull())

def unzip(archive_path=None, src_path=None):
    """Unzip a file using unzip"""
    command = ['unzip', archive_path, '-d', src_path]
    return subprocess.call(command, stdout=devnull())

def make_virtual_environment(name=None, module=None, python_executable=None):
    """Make a virtual environment for merge4u"""
    command = [python_executable, module, '-p', python_executable, name]
    return subprocess.call(command, stdout=devnull())

def make_dependency_install_script(name=None, dep_list=None, venv=None):
    """Make a script to install dependencies into a virtual environment"""
    pip_list = ['pip install ' + dep for dep in dep_list]
    line_list = [
        '',
        '# print out the contents of this install script',
        'cat ' + name,
        '',
        '# source the virtualenv bin activate file',
        'source ' + venv + '/bin/activate',
        '',
        '# install the dependencies',
        'echo',
        'echo "Installing Dependencies"',
    ] + pip_list + [
        '',
        '# print installed packages',
        'echo',
        'echo "Packages Installed In Virtualenv"',
        'pip freeze',
        '',
        '# deactivate the virtual env',
        'deactivate',
        '',
        '# delete the install script',
        'rm ' + name,
        '',
        '',
    ]

    script_content = '\n'.join(line_list)
    script = open(name, 'w')
    script.write(script_content)
    script.close()

def make_setup_script(
        filename=None,
        install_path=None,
        src_path=None,
        venvname=None
):
    """Make a script setup the users shell to use merge4u"""
    config_path = os.path.join(install_path, 'config.json')
    parent_path = os.path.join(install_path, src_path)
    activate_path = os.path.join(install_path, venvname, 'bin', 'activate')
    merge4u_path = os.path.join(parent_path, 'merge4u')
    tab_path = os.path.join(
        merge4u_path, 'install', 'merge', 'command_line_completion.py')
    m4ushell_path = os.path.join(merge4u_path, 'merge', 'convergence', 'run.py')

    line_list = [
        '# Set your config file',
        'export MERGE4U_SHELL_CONFIG=' + config_path,
        '',
        '# Set your python path indirectly',
        'export MERGE4U_PARENT_DIRECTORY=' + parent_path,
        '',
        '# Activate your python virtual environment',
        'source ' + activate_path,
        '',
        '# Configuring tab completion for the merge4u cli tool',
        'source $(python ' + tab_path + ' --name m4ushell)',
        '',
        '# Shortcut for running the merge4u program',
        "alias m4ushell='python " + m4ushell_path + "'",
        '',
        '',
    ]
    content = '\n'.join(line_list)
    setup_script_file = open(filename, 'w')
    setup_script_file.write(content)
    setup_script_file.close()

def generate_merge4u_setup_alias(filename=None):
    """Generate a bash alias to setup merge4u"""
    return "alias setup_merge4u='source " + filename + "'"

def append_setup_call_to_bashrc(alias=None):
    """Append alias definition to bashrc"""
    line_list = [
        '',
        '',
        '# The Alias To Setup Merge4u',
        alias,
        '',
        '',
    ]
    content = '\n'.join(line_list)
    bashrc_file = open(os.path.expanduser('~/.bashrc'), 'a')
    bashrc_file.write(content)
    bashrc_file.close()

def make_alias_invoking_script(
        filename=None,
        install_deps_script_name=None,
        setup_alias=None,
        setup_script_name=None
):
    """Make a script to run the dependency installer and setup script"""
    line_list = [
        '',
        '# print out the contents of this install script',
        'cat ' + filename,
        '',
        '# source the install deps script',
        'source ' + install_deps_script_name,
        '',
        '# assign a setup alias for the current shell',
        setup_alias,
        '',
        '# source the setup script',
        'source ' + setup_script_name,
        '',
        '# delete this script',
        'rm ' + filename,
        '',
        '',
    ]
    content = '\n'.join(line_list)
    script_sourcer_file = open(filename, 'w')
    script_sourcer_file.write(content)
    script_sourcer_file.close()

if __name__ == '__main__':
    RESULT = run()
    if RESULT:
        print(RESULT)

