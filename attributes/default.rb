#
# Environment, can be onprem or Azure
#
default['environment'] = 'onprem' # onprem or azure
default['temporal_tables']['config'] = true

#
# Helpers to configure Cookbook
#
default['cookbook']['name'] = 'postgresql'

#
# Packages to Install
#
default['onprem']['platform_v_7']['pkg_to_install'] = ['rh-postgresql96', 'rh-postgresql96-postgresql-contrib-syspaths', 'rh-postgresql96-postgresql-syspaths','rh-postgresql96-postgresql-devel']
default['azure']['platform_v_7']['pkg_to_install']  = ['rh-postgresql96', 'rh-postgresql96-postgresql-contrib-syspaths', 'rh-postgresql96-postgresql-syspaths','rh-postgresql96-postgresql-devel']

default['onprem']['platform_v_6']['pkg_to_install'] = ['rh-postgresql96', 'rh-postgresql96-postgresql-contrib-syspaths', 'rh-postgresql96-postgresql-syspaths','rh-postgresql96-postgresql-devel']
default['azure']['platform_v_6']['pkg_to_install']  = ['rh-postgresql96', 'rh-postgresql96-postgresql-contrib-syspaths', 'rh-postgresql96-postgresql-syspaths','rh-postgresql96-postgresql-devel']

#
# Helpers to configure PostgreSQL
#
default['postgresql']['service_name'] = 'rh-postgresql96-postgresql'
default['postgresql']['data_dir'] = '/var/opt/rh/rh-postgresql96/lib/pgsql/data'
default['postgresql']['config']['listen_addresses'] = '*'

#
# Helpers for Temporal Tables
#
default['onprem']['temporal_tables'] = ['gcc','python-setuptools']
default['azure']['temporal_tables']  = ['gcc','python-setuptools']

#
# Firewall Config
#
default['firewall']['config'] = false
default['firewall']['firewalld']['permanent'] = true
default['firewall']['open_ports'] = [22,5432]