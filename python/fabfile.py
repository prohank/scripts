import csv

# install fabric version < 2 following script is for less than v2.0
# $pip install 'fabric<2.0'

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
       
