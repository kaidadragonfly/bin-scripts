#!/usr/bin/env python
"""
Daemon to run sbt in the background and pass information back/forward over a
port.
"""
import logging, socket, subprocess

from daemon import runner       # pylint: disable=no-name-in-module

def dispatch(workdir, command):
    """Determine whether we will "foreground" or "background"."""
    if command[0] == '~':
        background(workdir, command)
    else:
        foreground(workdir, command)

def background(workdir, command):
    """Run "command" in a new subprocess in the background."""
    return "Background not implemented!: {} {}".format(workdir, command)

def foreground(workdir, command):
    """Run "command" using the persistent SBT process for "workdir"."""
    proc = subprocess.Popen(['sbt', '-Dsbt.log.noformat=true', command],
                            cwd=workdir,
                            stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    out, err = proc.communicate(command)
    return "{} {}: {}\n{}".format(workdir, command, out, err)

class App():                    # pylint: disable=too-few-public-methods
    """Wrapper class for main logic."""
    def __init__(self):
        self.stdin_path = '/dev/null'
        self.stdout_path = '/dev/null'
        self.stderr_path = '/tmp/sbtd.err'
        self.pidfile_path = '/tmp/sbtd.pid'
        self.pidfile_timeout = 5

    def run(self):              # pylint: disable=no-self-use
        """
        Main loop.

        Initializes and listens to socket, and calls out to subprocess.
        """
        logging.basicConfig(filename='/tmp/sbtd.log',
                            filemode='w+',
                            level=logging.INFO)
        logger = logging.getLogger(__name__)

        srv = socket.socket()
        srv.bind(('localhost', 3587))
        srv.listen(5)

        while True:
            client, addr = srv.accept()
            logger.info("Got connection from %s", addr)
            workdir = client.recv(4096).rstrip()
            command = client.recv(4096).rstrip()
            client.send(foreground(workdir, command))
            client.close()

def main():
    """Bootstrap the daemon."""
    app = App()
    daemon_runner = runner.DaemonRunner(app)
    daemon_runner.do_action()

main()
