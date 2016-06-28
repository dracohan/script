"""Miscellaneous branch operations"""

import os
import subprocess
import re
import tempfile
import sys

def cbsmergedb(
        cbsmergedb_executable_path=None,
        database=None,
        log_dir_path=None,
        host=None,
        changelist_number=None
):
    """Execute cbsmergedb to save te change to the database"""
    arg_list = [
        cbsmergedb_executable_path,
        '--database', database,
        '--file', log_dir_path + '/json',
        '--host', host,
        '--change', '@' + changelist_number,
    ]

    cbsmergedb_process = subprocess.Popen(
        arg_list,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
    )
    cmd_output = cbsmergedb_process.communicate()[0]
    output_file = open(os.path.join(log_dir_path, 'mergedb'), 'w')
    output_file.write(cmd_output)
    output_file.close()

def update_template(
        file_path=None,
        fromCLN=None,
        branch=None,
        fromBranch=None,
        count=None
):
    """Generate changelist template with skeleton"""
    dst_handle = tempfile.TemporaryFile()
    src_handle = open(file_path, 'r')
    for line in src_handle:
        line = re.sub(r'<fromCLN>', fromCLN, line)
        line = re.sub(r'<branch>', branch, line)
        line = re.sub(r'<fromBranch>', fromBranch, line)
        line = re.sub(r'<num>', count, line)
        dst_handle.write(line)
    src_handle.close()
    dst_handle.seek(0)
    return dst_handle.read()

def get_integ_branch(
        branch=None,
        fromBranch=None
):
    """Get data needed to rollback integration"""
    devnull = open(os.devnull, 'w')
    arg_list = ['fromto2branchr', fromBranch, branch]
    branch_process = subprocess.Popen(
        arg_list, stdout=subprocess.PIPE, stderr=devnull)
    integ_info = branch_process.communicate()[0]
    devnull.close()
    integ_branch = integ_info.split(' ')[0]
    integ_reverse = integ_info.split(' ')[1].strip(' \n')
    if integ_reverse == '-':
        integ_reverse = ''
    print "integBranch is", "=>", integ_branch
    print "integReverse is", "=>", integ_reverse
    return {
        'integBranch' : integ_branch,
        'integReverse' : integ_reverse,
    }


if __name__ == '__main__':
    cbsmergedb(
        cbsmergedb_executable_path='/home/aka3sand/vmware/merge4u/merge4u/junk.py',
        database='cbsmerge',
        log_dir_path='/var/log/m4u',
        host='sc-prd-bms-db001',
        changelist_number='3832343'
    )

