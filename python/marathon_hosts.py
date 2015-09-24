#!/usr/bin/env python3
"""
Print a list of hosts for a given app, one per line.
"""
from urllib.request import urlopen
import json
import re


def find_hostnames(host, app):
    """
    Find the hostnames for app.
    """
    prefix = re.sub(r'marathon.aws-[a-z]+-[a-z]+-[0-9]+-', '', host)
    prefix = re.sub(r'[.].+', '', prefix)

    url = "http://{host}/v2/apps/{prefix}/{app}".format(host=host,
                                                        prefix=prefix,
                                                        app=app)
    resp = urlopen(url).read().decode('utf-8')
    tasks = json.loads(resp)['app']['tasks']
    return [t['host'] for t in tasks]


if __name__ == '__main__':
    import sys

    if len(sys.argv) <= 2:
        print("HOSTNAME, and APP_NAME are required")
        print("usage: {} HOSTNAME APP_NAME".format(sys.argv[0]))
        exit(1)

    for host_name in find_hostnames(sys.argv[1], sys.argv[2]):
        print(host_name)
