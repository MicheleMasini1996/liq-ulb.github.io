#!/usr/bin/env python3
import sys
from getpass import getpass
from pysftp import Connection
from paramiko.ssh_exception import AuthenticationException



source_dir = '_site/'
dest_dir = 'public_html/'



try:
    name = sys.argv[0]
except IndexError:
    name = "deploy.py"

try:
    user, hostname = sys.argv[1].split('@')
except:
    sys.exit('Use: {} username@hostname'.format(name))

passwd = getpass(prompt="{}@{}'s password: ".format(user, hostname))



try:
    with Connection(hostname, username=user, password=passwd) as sftp:
        rm = sftp.remove

        def cleardir(path):
            sftp.walktree(path, rm, rmdir, rm, recurse=False)

        def rmdir(path):
            cleardir(path)
            sftp.rmdir(path)
    
        cleardir(dest_dir)
        sftp.put_r(source_dir, dest_dir)
except AuthenticationException:
    sys.exit('{}: Authentication failure.'.format(name))
