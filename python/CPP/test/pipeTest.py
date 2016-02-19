import logging
import shlex
import subprocess
import os

from subprocess import check_output
import signal


def run_shell_commands(cmds):
    """ Run commands and return output from last call to subprocess.Popen.
        For usage see the test below.
    """
    # split the commands
    cmds = cmds.split("|")
    cmds = list(map(shlex.split,cmds))

    logging.info('%s' % (cmds,))

    # run the commands
    stdout_old = None
    stderr_old = None
    p = []
    for cmd in cmds:
        logging.info('%s' % (cmd,))
        p.append(subprocess.Popen(cmd,stdin=stdout_old,stdout=subprocess.PIPE))
        stdout_old = p[-1].stdout
    p[-2].stdout.close()
    return p[-1]

def restore_signals(): # from http://hg.python.org/cpython/rev/768722b2ae0a/
    signals = ('SIGPIPE', 'SIGXFZ', 'SIGXFSZ')
    for sig in signals:
        if hasattr(signal, sig):
            signal.signal(getattr(signal, sig), signal.SIG_DFL)

def permit_sigpipe():
    signal.signal(signal.SIGPIPE, signal.EPIPE)

def foo():
    #cmd = "yes | ls"
    #p = run_shell_commands(cmd)
    #p = subprocess.Popen(shlex.split(cmd.encode('ascii')), preexec_fn=permit_sigpipe())
    #p.communicate()
    cmd1 = "yes "
    cmd2 = "date"
    p1 = subprocess.Popen(shlex.split(cmd1.encode('ascii')), stdout=subprocess.PIPE, preexec_fn=permit_sigpipe())
    p2 = subprocess.Popen(shlex.split(cmd2), stdin=p1.stdout,
                          stdout=subprocess.PIPE)
    p1.stdout.close()
    output = p2.communicate()[0]

    #subprocess.check_output("yes | ls", shell=True, preexec_fn=permit_sigpipe())
    print(os.getcwd())

#foo()