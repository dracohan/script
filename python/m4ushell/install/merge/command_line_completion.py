#!/usr/bin/python

"""Generate a bash script to add tab completion functionality"""

import argparse
import datetime
import sys

PARSER = argparse.ArgumentParser(
    prog='merge4u_merge_clc_installer',
    description='Installs command line completion for the merge program.'
)
PARSER.add_argument(
    '--name',
    required=True,
    help='name used to run the merge program'
)

def generate_installer(**kwargs):
    """Generate a bash script to add tab completion functionality"""
    namespace = PARSER.parse_args(args=sys.argv[1:])
    now = datetime.datetime.now()
    filename = 'clc_installer' + now.strftime('%Y_%m_%d_%H_%M') + '.bash'
    command_name = namespace.name
    comp_list = [
        # args
        '--help',
        '--out',
        '--branch',
        '--from-branch',
        '--from-cln',
        '--plugin',
        '--client',
        '--clientname',
        '--p4port',
        # reflection
        'reflection',
        'sync_bmps_config',
        # p4client
        'p4client',
        'create',
        # callcmd
        'callcmd',
        'cbsMerge1',
        # branch
        'branch',
        'summary',
        'printenv',
        'perform_test',
        'configenv',
        'prepare_conflict_resolution',
        'sync',
        'resolve_minus_d',
        'setup_workspace',
    ]
    comp_list_string = ' '.join(comp_list)

    line_list = [
        '_%s_merge_clc()' % command_name,
        '{',
        '    local cur=${COMP_WORDS[COMP_CWORD]}',
        '    COMPREPLY=( $(compgen -W "%s" -- $cur) )' % comp_list_string,
        '}',
        'complete -F _%s_merge_clc %s' % (command_name, command_name),
    ]

    line_list.append('')
    line_list.append('cat ' + filename)
    line_list.append('rm ' + filename)
    line_list.append('')

    content = '\n'.join(line_list)
    bash_file = open(filename, 'w')
    bash_file.write(content)
    bash_file.close()

    return filename

if __name__ == '__main__':
    FILENAME = generate_installer()
    print(FILENAME)

