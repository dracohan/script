"""Default operations for resolve_minus_d"""

import os

from merge4u.operation.branch import perforce
from merge4u.operation.branch import misc

class CreateChangelistOperation(object):
    """Create a new changelist"""
    def execute(self, *args, **kwargs):
        """Create a new changelist"""
        change_type = kwargs['change_type']
        from_cln = kwargs['fromCLN']
        branch = kwargs['branch']
        from_branch = kwargs['fromBranch']
        count = kwargs['count']
        change_template = get_change_template(
            change_type=change_type,
            fromCLN=from_cln,
            branch=branch,
            fromBranch=from_branch,
            count=count
        )

        changelist_number = perforce.create_changelist_from_template(
            change_template=change_template
        )
        return changelist_number

def get_change_template(*args, **kwargs):
    """Read a change template from a file relative to this source file"""
    change_type = kwargs['change_type']
    from_cln = kwargs['fromCLN']
    branch = kwargs['branch']
    from_branch = kwargs['fromBranch']
    count = kwargs['count']

    filename = change_type + '.txt'
    this_directory = os.path.split(os.path.abspath(__file__))[0]
    file_path = os.path.join(this_directory, 'default', filename)
    change_template = misc.update_template(
        file_path=file_path,
        fromCLN=from_cln,
        branch=branch,
        fromBranch=from_branch,
        count=count
    )
    return change_template

class ListDelHistoryOperation(object):
    """list deleted files history"""
    def execute(self, *args, **kwargs):
        """list deleted files history"""
        file_identifier = kwargs['file_identifier']
        branch = kwargs['branch']
        config = kwargs['config']
        perforce.list_del_history(file_identifier, branch, config)

class ReopenOperation(object):
    """Reopen file for edit within changelist"""
    def execute(self, *args, **kwargs):
        """Open file for edit within changelist"""
        changelist_number = kwargs['changelist_number']
        file_identifier = kwargs['file_identifier']
        perforce.reopen(
            changelist_number=changelist_number,
            file_path=file_identifier
        )

class PrepareDelEnvOperation(object):
    """Set integInfo and integBranch"""
    def execute(self, *args, **kwargs):
        """Set integInfo and integBranch"""
        branch = kwargs['branch']
        from_branch = kwargs['fromBranch']
        delconfig = misc.get_integ_branch(
            branch=branch,
            fromBranch=from_branch
        )
        return delconfig

class CallIntegOperation(object):
    """Call p4 integ for delete revisions"""
    def execute(self, *args, **kwargs):
        """Call p4 integ for delete revisions"""
        delconfig = kwargs['delconfig']
        from_cln = kwargs['fromCLN']
        deleted_file_list = perforce.integ_minus_d(
            delconfig=delconfig,
            fromCLN=from_cln
        )
        return deleted_file_list
