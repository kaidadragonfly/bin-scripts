#!/usr/bin/env python3
# Based on the example from here:
# https://docs.python.org/3/library/email.examples.html

import argparse
import os
import smtplib

# Here are the email package modules we'll need
from email.message import EmailMessage

def send_email(
        sender,
        to,
        subject,
        body,
        attachment_path,
        username,
        password,
        smtp_server):

    # Create the container email message.
    msg = EmailMessage()
    if subject:
        msg['Subject'] = subject
    elif body:
        msg['Subject'] = body[:31]
    elif attachment_path:
        msg['Subject'] = attachment_path
    msg['From'] = sender
    msg['To'] = to
    msg.preamble = 'You will not see this in a MIME-aware mail reader.\n'
    if body:
        msg.set_content(body)

    if attachment_path:
        extension = attachment_path.split('.')[-1]

        maintype = None
        subtype = None
        if extension == 'epub':
            maintype = 'application'
            subtype = 'epub+zip'
        elif extension == 'pdf':
            maintype = 'application'
            subtype = 'pdf'
        elif extension == 'mobi':
            maintype = 'application'
            subtype= 'x-mobipocket-ebook'

        if maintype and subtype:
            with open(attachment_path, 'rb') as fp:
                data = fp.read()
                msg.add_attachment(data,
                                   maintype=maintype,
                                   subtype=subtype,
                                   filename=os.path.basename(attachment_path))
        else:
            raise ValueError("Unsupported attachment type!")

    with smtplib.SMTP(smtp_server) as server:
        server.starttls()
        server.login(username, password)
        server.send_message(msg)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Send an email from gmail.')

    parser.add_argument('sender',
                        metavar='FROM',
                        type=str,
                        help='the sender of the email'
    )

    parser.add_argument('to',
                        metavar='TO',
                        type=str,
                        help='the recipient of the email'
    )

    parser.add_argument('--subject',
                        dest='subject',
                        type=str,
                        default='',
                        help='the subject of the email'
    )

    parser.add_argument('--attachment',
                        dest='path',
                        type=str,
                        default='',
                        help='the attachment for the email'
    )

    parser.add_argument('--body',
                        dest='body',
                        type=str,
                        default='',
                        help='the body of the message'
    )

    args = parser.parse_args()

    smtp_server = os.environ.get('SMTP_SERVER')
    username = os.environ.get('SMTP_USERNAME')
    password = os.environ.get('SMTP_PASSWORD')

    try:
        if not username:
            raise ValueError('Error SMTP_USERNAME not set!')
        if not password:
            raise ValueError('Error SMTP_PASSWORD not set!')

        send_email(
            args.sender,
            args.to,
            args.subject,
            args.body,
            args.path,
            username,
            password,
            smtp_server
        )
    except ValueError as e:
        print(e)
        exit(1)
