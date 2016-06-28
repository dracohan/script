"""Override the ClientCloner in interpret with this one"""

import os
import subprocess

from . import interpret

class Plugin(object):
    """Override the interpret module"""
    def get_dependency_set(self):
        """Get the dependency relations between plugins"""
        return set([('clone_override', 'interpret')])

    def load(self, context=None):
        """Load the interpreter"""
        interpret.PLUGIN.interpreter.client_cloner = ClientCloner()
        return context

class ClientCloner(object):
    """Clone a client from a template string"""
    def clone(self, user=None, branch_name=None, client_name=None):
        """Clone a client from a template string"""
        print('p4 client -i')
        root = os.getcwd()
        clientspec = make_client_spec(
            user=user,
            client_name=client_name,
            branch_name=branch_name,
            root=root
        )
        p4_client_process = subprocess.Popen(
            ['p4', 'client', '-i'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE
        )
        output = p4_client_process.communicate(input=clientspec)[0]
        print output,

def make_client_spec(user=None, client_name=None, branch_name=None, root=None):
    """Generate a clinetspec from a client name, branch, and root"""
    line_list = [
        "# A Perforce Client Specification.",
        "#",
        "#  Client:      The client name.",
        "#  Update:      The date this specification was last modified.",
        "#  Access:      The date this client was last used in any way.",
        "#  Owner:       The Perforce user name of the user who owns the client",
        "#               workspace. The default is the user who created the",
        "#               client workspace.",
        "#  Host:        If set, restricts access to the named host.",
        "#  Description: A short description of the client (optional).",
        "#  Root:        The base directory of the client workspace.",
        "#  AltRoots:    Up to two alternate client workspace roots.",
        "#  Options:     Client options:",
        "#                      [no]allwrite [no]clobber [no]compress",
        "#                      [un]locked [no]modtime [no]rmdir",
        "#  SubmitOptions:",
        "#                      submitunchanged/submitunchanged+reopen",
        "#                      revertunchanged/revertunchanged+reopen",
        "#                      leaveunchanged/leaveunchanged+reopen",
        "#  LineEnd:     Text file line endings on client: local/unix/mac/win/share.",
        "#  ServerID:    If set, restricts access to the named server.",
        "#  View:        Lines to map depot files into the client workspace.",
        "#  ChangeView:  Lines to restrict depot files to specific changelists.",
        "#  Stream:      The stream to which this client's view will be dedicated.",
        "#               (Files in stream paths can be submitted only by dedicated",
        "#               stream clients.) When this optional field is set, the",
        "#               View field will be automatically replaced by a stream",
        "#               view as the client spec is saved.",
        "#  StreamAtChange:  A changelist number that sets a back-in-time view of a",
        "#                   stream ( Stream field is required ).",
        "#                   Changes cannot be submitted when this field is set.",
        "#",
        "# Use 'p4 help client' to see more about client views and options.",
        "",
        "Client:\t{cn}",
        "",
        "Owner:\t{user}",
        "",
        "Root:\t{root}",
        "",
        "LineEnd:\tlocal",
        "",
        "View:",
        "\t//depot/bora/{bn}/... //{cn}/bora/{bn}/...",
        "\t//depot/bora-vmsoft/{bn}/... //{cn}/bora-vmsoft/{bn}/...",
        "\t//depot/vmkdrivers/{bn}/... //{cn}/vmkdrivers/{bn}/...",
        "\t//depot/scons/{bn}/... //{cn}/scons/{bn}/...",
        "\t//depot/mojo/{bn}/... //{cn}/mojo/{bn}/...",
        "\t//depot/biosbuild/{bn}/... //{cn}/biosbuild/{bn}/...",
        "\t//depot/BIOS2002/{bn}/... //{cn}/BIOS2002/{bn}/...",
        "\t//depot/EFIBIOS/{bn}/... //{cn}/EFIBIOS/{bn}/...",
        "\t//depot/EFIROM/{bn}/... //{cn}/EFIROM/{bn}/...",
        "\t//depot/PXEROM/{bn}/... //{cn}/PXEROM/{bn}/...",
        "\t//depot/SCSIBIOS/{bn}/... //{cn}/SCSIBIOS/{bn}/...",
        "\t//depot/VGABIOS/{bn}/... //{cn}/VGABIOS/{bn}/...",
        "\t//depot/vcqe/{bn}/... //{cn}/vcqe/{bn}/...",
        "\t//depot/alps/{bn}/... //{cn}/alps/{bn}/...",
        "\t//depot/logbrowser/{bn}/... //{cn}/logbrowser/{bn}/...",
        "\t//depot/cms/{bn}/... //{cn}/cms/{bn}/...",
        "\t//depot/cls/{bn}/... //{cn}/cls/{bn}/...",
        "\t//depot/vsphere-client-modules/{bn}/... //{cn}/vsphere-client-modules/{bn}/...",
        "\t//depot/manifest/{bn}/... //{cn}/manifest/{bn}/...",
        "\t//depot/smi-mibs/{bn}/... //{cn}/smi-mibs/{bn}/...",
        "\t//depot/applmgmt/{bn}/... //{cn}/applmgmt/{bn}/...",
        "\t//depot/lotus/{bn}/... //{cn}/lotus/{bn}/...",
        "\t//depot/vim-clients/{bn}/... //{cn}/vim-clients/{bn}/...",
        "\t//depot/hbrsrv-test/{bn}/... //{cn}/hbrsrv-test/{bn}/...",
        "\t//depot/dataservice/{bn}/... //{cn}/dataservice/{bn}/...",
        "\t//depot/lotus-qe/{bn}/... //{cn}/lotus-qe/{bn}/...",
        "\t//depot/syslog-essentials/{bn}/... //{cn}/syslog-essentials/{bn}/...",
        "\t//depot/vsan-mgmt-ui/{bn}/... //{cn}/vsan-mgmt-ui/{bn}/...",
        "",
    ]
    content = '\n'.join(line_list).format(
        user=user, cn=client_name, bn=branch_name, root=root)
    return content

PLUGIN = Plugin()

