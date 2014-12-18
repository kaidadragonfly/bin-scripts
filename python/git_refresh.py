#!/usr/bin/env python
"""
Perform a 'git pull --ff-only' and a 'git fetch --tags'.
"""
from sh import ErrorReturnCode # pylint: disable=no-name-in-module

from git_utils import wrap, git, svn_repo

def refresh():
    """
    Perform a 'git pull --ff-only' and a 'git fetch --tags'.
    """
    git.fetch()
    output = str(git.merge('--ff-only')).strip()
    if output != 'Already up-to-date.':
        print(output)
    git.fetch('--tags')

def svn_rebase():
    """
    Perform a 'git svn rebase' on the repository.

    Back it out if it fails.
    """
    output = str(git.svn.rebase()).strip()
    if not output.endswith('Current branch master is up to date.'):
        print('"' + output + '"')

def main():
    """Top level."""
    try:
        if not svn_repo():
            refresh()
        else:
            svn_rebase()

    except ErrorReturnCode as ex:
        full_cmd = ex.full_cmd.split()
        cmd = (full_cmd[0]).split('/')[-1]
        args = ' '.join(full_cmd[1:])

        if 'no remote' not in ex.stderr.lower():
            print(wrap('Command "{} {}" failed!'.format(cmd, args)))
            print()
            print(ex.stderr)

if __name__ == '__main__':
    main()
