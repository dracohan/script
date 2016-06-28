"""Read and generate values for the environment"""

import os

NAME_LIST = [
    'mergetopdir',
    'mergesource',
    'mergeprocess',
    'mergeprocessbin',
    'mergeproto',
    'mergeprotobin',
    'logtopdir',
    'logdir',
    'PATH',
    'branch',
    'fromBranch',
    'fromCLN',
    'P4CLIENT',
    'P4PORT',
    'partialArg',
]

def read():
    """Return environment values as a list of pairs."""
    return [(name, os.environ.get(name, '')) for name in NAME_LIST]

def generate_name_value_pair_list(parameter_map=None, config=None):
    """Output pairs that environment variables will be set to"""
    path = parameter_map['path']
    username = parameter_map['username']
    branch = parameter_map['branch']
    clientname = parameter_map['clientname']
    from_branch = parameter_map['from_branch']
    from_cln = parameter_map['from_cln']
    p4port = parameter_map['p4port']
    current_time = parameter_map['current_time']

    result = []

    merge_top_dir = config['merge_top_dir']
    result.append(('mergetopdir', merge_top_dir))

    merge_source = merge_top_dir
    result.append(('mergesource', merge_source))

    merge_process = os.path.join('bms', 'main', 'src', 'mergeprocess')
    result.append(('mergeprocess', merge_process))

    merge_process_bin = os.path.join(merge_source, merge_process, 'bin')
    result.append(('mergeprocessbin', merge_process_bin))
    if merge_process_bin not in path:
        path += ':' + merge_process_bin

    merge_proto = os.path.join('bms', 'main', 'src', 'cbsmerge', 'prototype')
    result.append(('mergeproto', merge_proto))

    merge_proto_bin = os.path.join(merge_source, merge_proto, 'bin')
    result.append(('mergeprotobin', merge_proto_bin))
    if merge_proto_bin not in path:
        path += ':' + merge_proto_bin

    result.append(('PATH', path))

    log_top_dir = config['log_top_dir']
    result.append(('logtopdir', log_top_dir))

    result.append(('branch', branch))
    result.append(('fromBranch', from_branch))
    result.append(('P4CLIENT', clientname))
    result.append(('P4PORT', p4port))
    result.append(('partialArg', ''))

    result.append(('fromCLN', from_cln))

    timestamp = current_time.strftime('%Y-%m-%d-%H-%M')
    result.append(('logdir', os.path.join(log_top_dir, '%s-%s-%s' % (
        from_branch, branch, timestamp))))

    return result

def create_config_script(parameter_map=None, config=None):
    """Create a script that will set environment variables."""
    head = generate_name_value_pair_list(
        parameter_map=parameter_map, config=config
    )
    result = ['']
    for name, value in head:
        result.append('export %s=%s\n' % (name, value))
    return ''.join(result)

