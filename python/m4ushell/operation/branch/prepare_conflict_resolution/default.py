"""Default operations for prepare_conflict_resolution"""

import os

from merge4u.operation.branch import perforce
from merge4u.operation.branch import misc

class ListUnresolvedOperation(object):
    """Find the files that have unresolved conflicts"""
    def execute(self, *args, **kwargs):
        """Find the files that have unresolved conflicts"""
        changelist_number = kwargs['changelist_number']
        unresolved_file_list = perforce.list_unresolved(
            changelist_number=changelist_number
        )
        return unresolved_file_list

class CheckHasFilesOpenedOperation(object):
    """Check if a changelist has any files open"""
    def execute(self, *args, **kwargs):
        """Check if a changelist has any files open"""
        changelist_number = kwargs['changelist_number']
        check = perforce.check_has_files_opened(
            changelist_number=changelist_number
        )
        return check

class RemoveFromChangelistOperation(object):
    """Remove a file from the changelist"""
    def execute(self, *args, **kwargs):
        """Remove a file from the changelist"""
        changelist_number = kwargs['changelist_number']
        file_identifier = kwargs['file_identifier']
        perforce.remove_from_changelist(
            changelist_number=changelist_number,
            file_path=file_identifier
        )

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

def add_file_list_to_template(change_template, file_list):
    """Add files to a change template"""
    line_list = ['\t' + filename for filename in file_list]
    updated_template = '\n'.join([change_template] + line_list)
    return updated_template

class SubmitOperation(object):
    """Submit a changelist"""
    def execute(self, *args, **kwargs):
        """Submit a changelist"""
        changelist_number = kwargs.get('changelist_number')
        if changelist_number:
            perforce.submit_changelist(changelist_number=changelist_number)
            return
        change_type = kwargs['change_type']
        change_template = get_change_template(change_type)
        file_list = kwargs['file_list']
        updated_template = add_file_list_to_template(
            change_template, file_list)
        perforce.submit_default(updated_template)

class CBSMergeDBOperation(object):
    """Update the merge database"""
    def execute(self, *args, **kwargs):
        """Update the merge database"""
        config = kwargs['config']
        cbsmergedb_config = config['cbsmergedb']
        misc.cbsmergedb(
            cbsmergedb_executable_path=cbsmergedb_config['executable_path'],
            database=cbsmergedb_config['database_name'],
            log_dir_path=cbsmergedb_config['log_dir_path'],
            host=cbsmergedb_config['database_host'],
            changelist_number=kwargs['changelist_number']
        )

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

class RetrievePendingChangelistOperation(object):
    """Retrieve the pending changelist number after call cbsMerge1"""
    def execute(self, *args, **kwargs):
        """Retrieve the pending changelist number after call cbsMerge1"""
        changelist_number = perforce.retrieve_pending_changelist(
            *args, **kwargs)
        return changelist_number

class ResolveSavingConflictOperation(object):
    """Save the conflicts"""
    def execute(self, *args, **kwargs):
        """Save the conflicts"""
        changelist_number = kwargs['changelist_number']
        perforce.resolve_save_conflict(changelist_number=changelist_number)

class EditOperation(object):
    """Open file for edit within changelist"""
    def execute(self, *args, **kwargs):
        """Open file for edit within changelist"""
        changelist_number = kwargs['changelist_number']
        file_identifier = kwargs['file_identifier']
        perforce.edit(
            changelist_number=changelist_number,
            file_path=file_identifier
        )

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

