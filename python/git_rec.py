#!/usr/bin/env python
"""
Recursively walk the current directory looking for git repositories.

Then run the specified git command on each directory.
"""
from git_utils import git, ErrorReturnCode, wrap
from os import walk, chdir, getcwd
from sys import stdout, argv

if __name__ == '__main__':
    stdout.write('Locating repositories...')
    stdout.flush()
    REPOS = []
    for root, dirs, files in walk('.', topdown=True):
        if '.git' in dirs:
            REPOS.append(root)
        dirs[:] = [d for d in dirs if not d[0] == '.']
    print(' done.')

    ROOT_DIR = getcwd()
    for repo in REPOS:
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
            print(wrap('Command: "{}" failed!'.format(ex.full_cmd)))
        chdir(ROOT_DIR)
