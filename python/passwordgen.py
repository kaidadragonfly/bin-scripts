#!/usr/bin/env python
from os import urandom
from string import letters, digits, punctuation
from optparse import OptionParser

def passgen(alphabet, length = 10):
    passw = ""
    while len(passw) < int(length):
        c = urandom(1)
        if (c in alphabet):
            passw += c
    return passw

parser = OptionParser()
parser.add_option("-l",
                  "--letters",
                  action="store_true",
                  help="output letters in the password")
parser.add_option("-n",
                  "--numbers",
                  action="store_true",
                  help="output numbers in the password")
parser.add_option("-p",
                  "--punctuation",
                  action="store_true",
                  help="output punctuation in the password")
parser.add_option("-s",
                  "--spaces",
                  action="store_true",
                  help="output spaces in the password")

(opts, args) = parser.parse_args()

chars = ''
if opts.letters:
    chars += letters
if opts.numbers:
    chars += digits
if opts.punctuation:
    chars += punctuation
if opts.spaces:
    chars += ' '

ascii = ' ' + letters + digits + punctuation
    
print passgen(chars or ascii, *args)

