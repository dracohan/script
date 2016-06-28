"""Default operations for perform_test"""

from merge4u.operation.branch import perforce

class CheckOutREADME(object):
    """checkout README and place into a pending cln"""
    def execute(self, *args, **kwargs):
        """checkout README and place into a pending cln"""
        description = 'svs test'
        branch = kwargs['branch']
        changelist_number = perforce.create_changelist(
            description=description
        )
        perforce.checkout_readme_to_cln(
            changelist_number=changelist_number,
            branch=branch
        )
        return changelist_number

class LaunchSVS(object):
    """launch svs test"""
    def execute(self, *args, **kwargs):
        """launch svs test"""
        changelist_number = kwargs['changelist_number']
        branch = kwargs['branch']
        logdir = kwargs['logdir']
        perforce.launch_svs(changelist_number, branch, logdir)

class RevertAll(object):
    """revert all files in the changelist"""
    def execute(self, *args, **kwargs):
        """revert all files in the changelist"""
        changelist_number = kwargs['changelist_number']
        perforce.revert_all(changelist_number)

class DeleteCLN(object):
    """delete a specific cln"""
    def execute(self, *args, **kwargs):
        """delete a specific cln"""
        changelist_number = kwargs['changelist_number']
        perforce.delete_cln(changelist_number)

class GetTOTCLN(object):
    """get TOT cln"""
    def execute(self, *args, **kwargs):
        """get TOT cln"""
        tot_cln = perforce.get_tot_cln()
        return tot_cln

class LaunchSandbox(object):
    """launch sandbox test"""
    def execute(self, *args, **kwargs):
        """launch sandbox test"""
        tot_cln = kwargs['tot_cln']
        branch = kwargs['branch']
        logdir = kwargs['logdir']
        perforce.launch_sandbox(tot_cln, branch, logdir)


