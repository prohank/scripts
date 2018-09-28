import csv

# install fabric version < 2 following script is for less than v2.0
# $pip install 'fabric<2.0'
# execute command as below
# @task implies and command
# fab set_servers:<server-group-which-you-are-passing-as-argument-to-method> echo_server_name 
# e.g. $fab set_servers:stage-server-list1 echo_server_name

# NOTE: 
# 1. fab command will call any file with name fabfile or fabfile.py,
# 2. File name should be fabfile or fabfile.py
# 3. There should be one and only one file in particular directory

# more info: https://www.pythonforbeginners.com/systems-programming/how-to-use-fabric-in-python
# http://docs.fabfile.org/en/2.4/getting-started.html#addendum-the-fab-command-line-tool
# https://github.com/fabric/fabric


from fabric.api import env, parallel, run, task

from fabric.colors import green, red, yellow
from fabric.state import output

env.user = '<ssh-user-name>'
env.warn_only = True
#env.use_ssh_config = True
output['running'] = False
output['stdout'] = False

@task
def set_servers(server_group):
    env.servers = get_server_list(server_group)

def get_server_list(server_group):
    servers_list = []
    with open('my-servers.csv', 'rU') as serverlistfile:
        reader = csv.DictReader(serverlistfile)
        for row in reader:
            server = row[server_group]
            if (server and server.strip()):
                servers_list.append(server)
    return servers_list

@parallel(pool_size=5)
@task
def echo_server_name():
   for host in env.hosts:
       print host
       
