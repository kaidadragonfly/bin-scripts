#!/usr/bin/env python
"""
A random string generator, designed for easy generation of passwords.

Uses os.urandom as source of entropy.
"""

from os import urandom
from string import ascii_letters as letters, digits, punctuation
from argparse import ArgumentParser

def passgen(alphabet, length):
    """
    Actually perform the random string generation.
    """
    passw = ""
    while len(passw) < int(length):
        char = urandom(1).decode('utf-8', errors='replace')

        if char in alphabet:
            passw += char
    return passw

def main():
    """
    Collect the arguments, and fire off the random generation with
    appropriate parameters.
    """
    parser = ArgumentParser(description="Generate a random password.")
    parser.add_argument("-l",
                        "--letters",
                        action="store_true",
                        help="output letters in the password")
    parser.add_argument("-n",
                        "--numbers",
                        action="store_true",
                        help="output numbers in the password")
    parser.add_argument("-p",
                        "--punctuation",
                        action="store_true",
                        help="output punctuation in the password")
    parser.add_argument("-s",
                        "--spaces",
                        action="store_true",
                        help="output spaces in the password")
    parser.add_argument("length",
                        metavar='LENGTH',
                        type=int,
                        nargs='?',
                        help="the length of the password",
                        default=10)

    args = parser.parse_args()

    chars = ''
    if args.letters:
        chars += letters
    if args.numbers:
        chars += digits
    if args.punctuation:
        chars += punctuation
    if args.spaces:
        chars += ' '

    ascii_chars = ' ' + letters + digits + punctuation

    print(passgen(chars or ascii_chars, args.length))

if __name__ == '__main__':
    main()
