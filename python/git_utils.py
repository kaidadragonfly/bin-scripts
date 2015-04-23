"""
Utility functions for writing git plugins.
"""

# sh magically creates functions below it; this confuses pylint.
from sh import git              # pylint: disable=no-name-in-module
import functools
import textwrap

WRAPPER = textwrap.TextWrapper()


def wrap(string, indent=4):
    """
    Wrap the given line.
    """
    WRAPPER.initial_indent = indent * ' '
    WRAPPER.subsequent_indent = WRAPPER.initial_indent

    wrapped = WRAPPER.wrap(string)
    if len(wrapped):
        return functools.reduce(lambda x, y: x + '\n' + y, wrapped)
    else:
        return ''


def svn_repo():
    """
    Returns True if a git-svn repository.  False otherwise.
    """
    from os import path

    base_dir = str(git('rev-parse', '--show-toplevel')).strip()
    return path.isdir(base_dir + '/.git/svn')
