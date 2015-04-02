#!/usr/bin/env python
"""
Recursively walk the current directory looking for git repositories.

Then run the specified git command on each directory.
"""
from os import chdir, walk
from sys import stdout, argv
from multiprocessing import Process
from sh import ErrorReturnCode # pylint: disable=no-name-in-module

from git_utils import git, wrap

def do_command(repo):
    """
    Execute the command in the given repository.
    """
    try:
        chdir(repo)
        command = git(argv[1:])
        if len(command) > 0:
            # Empty string prevents printing the tuple in python2
            print('')
            print("in repo {}:".format(repo))
            for line in command:
                print(wrap(line))
                stdout.flush()

    except ErrorReturnCode as ex:
        print("in repo {}:".format(repo))
        print(wrap('Command failed!'))
        # print(wrap('Command: "{}" failed!'.format(ex.full_cmd)))

def main():
    """
    Main loop to dispatch workers.
    """
    # pylint: disable=not-callable
    # Process is reported as not callable.

    workers = []
    for root, dirs, _ in walk('.', topdown=True):
        if '.git' in dirs:
            dirs[:] = []
            worker = Process(target=do_command, args=(root,))
            worker.start()
            workers.append(worker)

    for worker in workers:
        worker.join()

if __name__ == '__main__':
    main()
