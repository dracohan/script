"""Simple perforce operations"""

import subprocess
import shlex
import time
import os
import sys
import re

from merge4u import constant

def list_unresolved(changelist_number=None):
    """List the unresolved files in a changelist"""
    arg_list = ['p4', 'resolve', '-n', '-c', changelist_number]
    print("p4 cmd: " + ' '.join(arg_list))
    list_process = subprocess.Popen(arg_list, stdout=subprocess.PIPE)
    file_path_list_string = list_process.communicate()[0]
    if not file_path_list_string:
        return []
    print("get " + repr(file_path_list_string.count("\n")) +
          " files that have conflicts")
    file_path_list = file_path_list_string.strip().split('\n')
    parsed_list = [file_path.split(' ')[0] for file_path in file_path_list]
    return list(set(parsed_list))

def contain_from_action(history_list):
    """
    :param history_list:
    :return: the action if found, or empty
    """
    for eachline in history_list:
        if eachline.count(' ') > 3 and eachline.split(' ')[3] == 'from':
            return eachline
    return ''

def get_from_action(file_identifier, latest_version=None):
    """
    :param file_identifier: filename
    :param latest_version: the current version
    :return: the latest version contain "from"
    """
    # if file_identifier contain #, use the last number as latest_version
    if file_identifier.count("#") != 0:
        latest_version = int(file_identifier[file_identifier.rindex("#")+1:])
        file_identifier = file_identifier[:file_identifier.index("#")]

    # if file_identifier contain @, strip it out of filename
    if file_identifier.count("@") != 0:
        file_identifier = file_identifier[:file_identifier.index("@")]

    # check exactly the latest_version
    history_list = get_change(file_identifier, latest_version)

    # return the action that contain "from"
    from_action = contain_from_action(history_list)
    if from_action == '':
        print "skipped. "
        latest_version -= 1
        prev_from_action = get_from_action(file_identifier, latest_version)
        return prev_from_action
    else:
        history_string = get_change(file_identifier, latest_version)
        print "Next change: \n" + '\n'.join(history_string),
        return from_action

def bool_source_branch(search_path, branch):
    """Check to see if the source path can be found"""
    star_main_branches = ["bfg-main", "vmkernel-main", "vmcore-main",
                          "storage-main", "vim-main"]
    # get the change type
    change = get_latest_change(search_path).split('\n')[1]
    change_type = get_change_type(change)

    # if edit, source found
    if change_type == 'edit' or change_type == 'add':
        print "Detected: edit/add change"
        return True
    # if delete, move/delete on *-main branch, source found
    elif (change_type == 'delete' \
                or change_type == 'move/delete') and branch in star_main_branches:
        print "Detected: delete change on *-main"
        return True
    # if not integrate, branch on *-main branch, source found
    elif change_type == 'integrate' and change_type == 'branch':
        return False
    # others, not found
    else:
        return False

def print_out_history(search_path, branch):
    """Print out the history"""
    if bool_source_branch(search_path, branch):
        print ">>>CONFLICTION<<<"
        latest_change = get_latest_change(search_path)
        print latest_change,
        print ">>>CONFLICTION<<<"
    else:
        latest_version = get_latest_version(search_path)
        search_path = get_next_search_path(search_path, latest_version)
        branch_name = get_branch_name(search_path)
        print_out_history(search_path, branch_name)

def list_del_history_branch(origin_search_path, search_path, first_branch, second_branch):
    """List the deletion history of a branch"""
    # print out the filelog on both first_branch and second_branch

    # if branch from filelog and fromBranch are same, find finish
    if first_branch == second_branch:
        print "Branching from same branch: " + first_branch + ". Finished."
        get_from_action(search_path)
        sys.exit()

    # find source change on first_branch
    print "Start search on local branch:", origin_search_path
    print_out_history(search_path, first_branch)

    # find source change on second_branch with #number replaced by @cln
    origin_search_path = re.sub(first_branch, second_branch, origin_search_path)
    #origin_search_path = origin_search_path[:origin_search_path.index('#')]
    origin_search_path = origin_search_path + "@" + os.environ['fromCLN']
    print "Continue search on fromBranch:", origin_search_path
    print_out_history(origin_search_path, second_branch)

def get_latest_change(search_path):
    """Get latest perforce change"""
    cmd = "p4 filelog -m1 " + search_path
    latest_history_list_string = run_shell_cmd(cmd, False)
    if latest_history_list_string.count('\n') < 2:
        print "Error: can't get latest change of : ", search_path
        sys.exit()
    return latest_history_list_string

def get_change(file_identifier, latest_version):
    """Get the change for the latest version of file"""
    cmd = "p4 filelog " + file_identifier + "#" + \
          repr(latest_version) + "," + "#" + repr(latest_version)
    history_string = run_shell_cmd(cmd, False)
    if history_string.count('\n') < 2:
        print "Error: can't get change of : ", file_identifier, "#", latest_version
        sys.exit()
    return history_string.split('\n')

def get_change_type(change):
    """Get change type"""
    return change.split(' ')[4]

def get_next_search_path(file_identifier, latest_version):
    """
    :param file_identifier: file path
    :param latest_version: the latest version
    :return: the next "from" path
    """
    from_action = get_from_action(file_identifier, int(latest_version))
    search_path = from_action.strip().split(' ')[-1]
    return search_path


def get_branch_name(search_path):
    """Get branch name"""
    branches = constant.BRANCH_LIST
    branch = None
    search_path_list = search_path.strip().split('/')
    for token in search_path_list:
        if token in branches:
            branch = token
            return branch

    if not branch:
        return 'unknown'

def get_latest_version(file_identifier):
    """
    :param file_identifier: file path on depot
    :return: string of latest version
    """
    latest_history_list_string = get_latest_change(file_identifier)
    latest_history_list = latest_history_list_string.strip().split('\n')
    latest_change = latest_history_list[1].split(' ')[1]
    latest_version = latest_change[latest_change.index("#")+1:]
    if not latest_version.isdigit():
        print "Error: latest version is in wrong format: ", latest_version
        sys.exit()
    return latest_version

def list_del_history(file_identifier, branch, config):
    """list deleted files history on both sides of conflicts"""

    # check the latest version on *-main-stage
    latest_version = get_latest_version(file_identifier)

    # get the first change contain "from" and return "from" where
    search_path = get_next_search_path(file_identifier, latest_version)

    # get the branch name to be replaced by from_branch
    first_branch = get_branch_name(file_identifier)

    # the second branch is fromBranch
    second_branch = os.environ['fromBranch']

    # figure out the real "from" branch
    origin_search_path = file_identifier
    list_del_history_branch(origin_search_path, search_path, first_branch, second_branch)


def check_has_files_opened(changelist_number=None):
    """Check the changelist to see if it has any opened files"""
    arg_list = ['p4', 'opened', '-m', '1', '-c', changelist_number]
    print("p4 cmd: " + ' '.join(arg_list))
    check_opened_process = subprocess.Popen(arg_list, stdout=subprocess.PIPE)
    file_path_list_string = check_opened_process.communicate()[0]
    return bool(file_path_list_string)

def resolve_save_conflict(changelist_number=None):
    """Resolve confilcts by saving the markers"""
    arg_list = ['p4', 'resolve', '-af', '-c', changelist_number]
    print("p4 cmd: " + ' '.join(arg_list))
    run_shell_cmd(' '.join(arg_list))
    # sleep 5 sec to let integ finish
    print("sleep 5 sec to let resolving finish...")
    time.sleep(5)
    print("done")

def remove_from_changelist(changelist_number, file_path=None):
    """Remove a file from the changelist"""
    arg_list = ['p4', 'revert', '-k', '-c', changelist_number, file_path]
    print("p4 cmd: " + ' '.join(arg_list))
    subprocess.call(arg_list)

def submit_changelist(changelist_number=None):
    """Submit a changelist"""
    arg_list = ['p4', 'submit', '-c', changelist_number]
    print("p4 cmd: " + ' '.join(arg_list))
    subprocess.call(arg_list)

def create_changelist_from_template(change_template=None):
    """Create a changelist using the change template"""
    arg_list = ['p4', 'change', '-i']
    print("p4 cmd: " + ' '.join(arg_list))
    make_changelist_process = subprocess.Popen(
        arg_list,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE
    )
    raw_output = make_changelist_process.communicate(input=change_template)[0]
    changelist_number = (
        raw_output.split('Change ') + [''])[1].split(' created.')[0]
    change_template.close()
    return changelist_number

def create_changelist(*args, **kwargs):
    """Clone a changelist from another with a new description"""
    # create a new changelist with description
    description = kwargs['description']
    cmd1 = "p4 change -o"
    cmd2 = "sed 's/\(<put\).*/" + description + "/g'"
    cmd3 = "p4 change -i"
    print("p4 cmd: " + cmd1 + "|" + cmd2 + "|" + cmd3)
    output_process = subprocess.Popen(shlex.split(cmd1), stdout=subprocess.PIPE)
    replace_process = subprocess.Popen(
        shlex.split(cmd2), stdin=output_process.stdout, stdout=subprocess.PIPE)
    input_process = subprocess.Popen(
        shlex.split(cmd3), stdin=replace_process.stdout, stdout=subprocess.PIPE)
    output_process.stdout.close()
    replace_process.stdout.close()
    output = input_process.communicate()[0]
    changelist_number = output[len("change") + 1:output.find(" created.")]
    time.sleep(3)
    return changelist_number

def checkout_readme_to_cln(changelist_number, branch):
    """Make a null change by checking the README file"""
    cmd = "p4 edit //depot/bora/" +branch + "/README"
    checkout_process = subprocess.Popen(shlex.split(cmd.encode('ascii')))
    print("executed: " + cmd)
    time.sleep(3)
    cmd = "p4 reopen -c " + changelist_number + \
          " //depot/bora/" +branch + "/README"
    print("p4 cmd: " + cmd)
    checkout_process = subprocess.Popen(shlex.split(cmd.encode('ascii')))
    time.sleep(3)

def launch_svs(changelist_number, branch, logdir):
    """Lauch svs test"""
    cmd = "run_test-esx " + branch + " " + changelist_number + \
          " > " + logdir + "/run_test-esx 2>&1"
    print("shell cmd: " + cmd)
    print("wait 15s to let svs start...")
    test_process = subprocess.Popen(shlex.split(cmd.encode('ascii')))
    time.sleep(15)

def launch_sandbox(tot_cln, branch, logdir):
    """Launch sandbox build"""
    cmd = "sh -x " + os.environ['mergeprocessbin'] + "/build_sandbox --branch " + \
           branch + " --cln " + tot_cln + " > " + logdir + \
           "/build_sandbox 2>&1"
    print("shell cmd: " + cmd)
    subprocess.call(cmd, shell=True)
    time.sleep(3)
    # TODO check launch result with run_test-esx

def revert_all(changelist_number):
    """Revert all files in a changelist"""
    cmd = "p4 revert -c " + changelist_number + " ..."
    print("p4 cmd: " + cmd)
    revert_process = subprocess.Popen(shlex.split(cmd.encode('ascii')))
    time.sleep(3)

def delete_cln(changelist_number):
    """Delete a changelist"""
    cmd = "p4 change -d " + changelist_number
    print("p4 cmd: " + cmd)
    delete_process = subprocess.Popen(shlex.split(cmd.encode('ascii')))
    time.sleep(3)

def get_tot_cln():
    """Get top of trunk cln"""
    cmd1 = "p4 changes ..."
    cmd2 = "head -1"
    print("p4 cmd: " + cmd1 + "|" + cmd2)
    list_change_process = subprocess.Popen(
        shlex.split(cmd1.encode('ascii')), stdout=subprocess.PIPE)
    head_process = subprocess.Popen(
        shlex.split(cmd2),
        stdin=list_change_process.stdout,
        stdout=subprocess.PIPE
    )
    list_change_process.stdout.close()
    output = head_process.communicate()[0]
    start_index = len("change") + 1
    end_index = output.find(" on ")
    tot_cln = output[start_index:end_index]
    time.sleep(3)
    print("the TOTcln is: %s" % tot_cln)
    return tot_cln

def retrieve_pending_changelist(*args, **kwargs):
    """Find a pending changelist for a client"""
    #Retrieve the pending changelist number after call cbsMerge1
    config = kwargs['config']
    parameter_map = kwargs['parameter_map']
    client_name = parameter_map.get('client')
    cmd = 'p4 changes -m1 -u ' + config['username'] + ' -s pending'
    if client_name:
        cmd += ' -c ' + client_name
    print("p4 cmd: " + cmd)
    list_change_process = subprocess.Popen(
        shlex.split(cmd.encode('ascii')), stdout=subprocess.PIPE)
    output = list_change_process.communicate()[0]

    #raise error when no pending changelist generated
    if output == '':
        print "output is: ", output
        print("ERROR: No pending changelist detected. "+(
            "Please check cbsMerge1 result firstly. "))
        return

    start_index = len("change") + 1
    end_index = output.find(" on ")
    changelist_number = output[start_index:end_index]
    print("the pending changelist nubmer is: %s"%changelist_number)
    return changelist_number

def edit(changelist_number=None, file_path=None):
    """Open a file for editing in the changelist"""
    arg_list = ['p4', 'edit', '-c', changelist_number, file_path]
    print("p4 cmd: " + ' '.join(arg_list))
    run_shell_cmd(' '.join(arg_list))


def reopen(changelist_number=None, file_path=None):
    """Open a file for editing in the changelist"""
    arg_list = ['p4', 'reopen', '-c', changelist_number, file_path]
    print("p4 cmd: " + ' '.join(arg_list))
    run_shell_cmd(' '.join(arg_list))
    # sleep 1 sec to let integ finish
    time.sleep(1)

def sync(force=None, cln=None, quiet=None):
    """Performs a sync in the current directory"""
    command = ['p4', 'sync']
    if force:
        command.append('-f')
    if cln:
        command.append('@' + cln)
    print("p4 cmd: " + ' '.join(command))
    if quiet:
        devnull = open(os.devnull, 'w')
        subprocess.call(command, stdout=devnull)
        devnull.close()
    else:
        subprocess.call(command)

def integ_minus_d(delconfig, fromCLN):
    """Integ deleted revisions"""
    # execute integ command
    cmd = ("p4 integ -Rd -Rb -i -t " + delconfig['integReverse'] +
           " -b "+ delconfig['integBranch'] + " //...@" + fromCLN)
    print("p4 cmd: " + cmd)
    file_path_list_string = run_shell_cmd(cmd, quiet=False)

    # no file integrated
    if not file_path_list_string:
        return []

    # print the file number
    print("get " + repr(file_path_list_string.count("\n")) +
          " files that have deleted revisions")

    # delete the version in the file name after # for reopen
    file_path_list = file_path_list_string.strip().split('\n')
    parsed_list = []
    for file_path in file_path_list:
        file_path = file_path.split(' ')[0]
        if file_path.count("#") > 0:
            file_path = file_path[:file_path.index("#")]
        parsed_list.append(file_path)
    return list(set(parsed_list))

def run_shell_cmd(cmd, quiet=True):
    """
    :param cmd: shell command want to execute
    :param quiet: suppress the stand output or not
    :return: shell output when not quiet
    """
    if quiet:
        devnull = open(os.devnull, 'w')
        cmd_process = subprocess.Popen(cmd, stdout=devnull, shell=True)
        devnull.close()
    else:
        cmd_process = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
        output = cmd_process.communicate()[0]
        return output

def is_logged_in():
    """Check if user is logged into perforce"""
    return not subprocess.call(['p4', 'login', '-s'])

def log_in():
    """Log user into perforce"""
    return not subprocess.call(['p4', 'login'])

