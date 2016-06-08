#!/usr/bin/env python
"""
Recursively walk the current directory looking for git repositories.

Then run the specified git command on each directory.
"""
from os import chdir, walk, path
from sys import stdout, argv
from multiprocessing import Process, Queue  # pylint: disable=no-name-in-module
from sh import ErrorReturnCode              # pylint: disable=no-name-in-module

from git_utils import git, wrap


def do_command(repo, queue):
    """
    Execute the command in the given repository.
    """
    try:
        chdir(repo)
        command = git(argv[1:])
        if len(command) > 0:
            # Empty string prevents printing the tuple in python2
            output = ''
            output += '\n'
            output += 'in repo {}:\n'.format(repo)
            for line in command:
                output += '{}\n'.format(wrap(line))
            queue.put(output)

    except ErrorReturnCode as ex:
        error = ''
        error += "in repo {}:".format(repo)
        error += wrap('Command: "{}" failed!\n'.format(ex.full_cmd))
        queue.put(error)


def printer(queue):
    """
    Print from queue until it contains 'None'.
    """
    item = queue.get()
    while item:
        stdout.write(item)
        stdout.flush()
        item = queue.get()


def main():
    """
    Main loop to dispatch workers.
    """
    # pylint: disable=not-callable
    # Process is reported as not callable.

    workers = []
    output_queue = Queue()
    root = path.realpath('.')
    for base, dirs, _ in walk('.', topdown=True):
        if '.git' in dirs and path.realpath(base) != root:
            dirs[:] = []
            worker = Process(target=do_command, args=(base, output_queue))
            worker.start()
            workers.append(worker)

    printer_worker = Process(target=printer, args=(output_queue,))
    printer_worker.start()

    for worker in workers:
        worker.join()
    output_queue.put(None)

    printer_worker.join()

if __name__ == '__main__':
    main()
