"""Define a class that can specify the file structure for workflow"""

import os

class HomeDirectoryComputer(object):
    def compute(self, *args, **kwargs):
        return self.back_config['home_dir']

class MergeTopDirectoryComputer(object):
    def compute(self, *args, **kwargs):
        default = os.path.join('integ', 'cbsmerge', 'integ')
        merge_top_dir = self.back_config.get('merge_top_dir', default)
        home_dir = self.front_config['home_dir']
        return os.path.join(home_dir, merge_top_dir)

class LogTopDirectoryComputer(object):
    def compute(self, *args, **kwargs):
        merge_top_dir = self.front_config['merge_top_dir']
        return os.path.join(merge_top_dir, 'logs')

class BMPSConfigRootComputer(object):
    def compute(self, *args, **kwargs):
        default = 'bmps_config'
        bmps_config_root = self.back_config.get('bmps_config_root', default)
        home_dir = self.front_config['home_dir']
        return os.path.join(home_dir, bmps_config_root)

class ConfigFacade(object):
    def __contains__(self, key):
        return key in self.value_computer_map

    def __getitem__(self, key):
        return self.value_computer_map[key].compute()

    def get(self, key, default=None):
        return self[key] if key in self else default

def make_front_config(*args, **kwargs):
    back_config = kwargs['back_config']
    value_computer_map = {}
    front_config = ConfigFacade()
    front_config.value_computer_map = value_computer_map

    home_dir = HomeDirectoryComputer()
    home_dir.back_config = back_config
    value_computer_map['home_dir'] = home_dir

    merge_top_dir = MergeTopDirectoryComputer()
    merge_top_dir.back_config = back_config
    merge_top_dir.front_config = front_config
    value_computer_map['merge_top_dir'] = merge_top_dir

    log_top_dir = LogTopDirectoryComputer()
    log_top_dir.front_config = front_config
    value_computer_map['log_top_dir'] = log_top_dir

    bmps_config_root = BMPSConfigRootComputer()
    bmps_config_root.back_config = back_config
    bmps_config_root.front_config = front_config
    value_computer_map['bmps_config_root'] = bmps_config_root

    return front_config

class BranchDirectoryComputer(object):
    def compute(self, *args, **kwargs):
        branch = kwargs['branch']
        home_dir = self.front_config['home_dir']
        return os.path.join(home_dir, 'integ', branch, 'integ')

class BranchConfigFacade(object):
    def __contains__(self, key):
        return True

    def __getitem__(self, key):
        return self.computer.compute(branch=key)

    def get(self, key, default):
        return self[key] if key in self else default

def make_branch_config(*args, **kwargs):
    front_config = kwargs['front_config']

    computer = BranchDirectoryComputer()
    computer.front_config = front_config

    branch_config = BranchConfigFacade()
    branch_config.computer = computer

    return branch_config

