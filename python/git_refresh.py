#!/usr/bin/env python
"""
Perform a 'git pull --ff-only' and a 'git fetch --tags'.
"""
from git_utils import wrap, git, svn_repo, ErrorReturnCode

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

if __name__ == '__main__':
    try:
        if not svn_repo():
            refresh()
        else:
            svn_rebase()

    except ErrorReturnCode as ex:
        print(wrap('Command: "{}" failed!'.format(ex.full_cmd)))
