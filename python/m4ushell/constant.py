"""misc constants"""

CLI_HELP_EPILOG = '\n'.join([
    'Send bugs to:',
    '    akagioglu@vmware.com   (Palo Alto)',
    '    hanb@vmware.com        (Shanghai)',
])

P4PORT_NAME_MAP = {
    'test': 'w3-perforce16.eng.vmware.com:1942',
    'read': 'perforce-ro.eng.vmware.com:1666',
    'prod': 'perforce.eng.vmware.com:1666',
    'qa': 'perforce-qa.eng.vmware.com:1666',
    'odtf': 'perforce-qa-odtf.eng.vmware.com:1666',
    'releng': 'perforce-releng.eng.vmware.com:1850',
}

BRANCH_LIST = [
    'main',
    'bfg-main',
    'bfg-main-stage',
    'storage-main',
    'storage-main-stage',
    'vim-main',
    'vim-main-stage',
    'vmcore-main',
    'vmcore-main-stage',
    'vmkernel-main',
    'vmkernel-main-stage',
]

