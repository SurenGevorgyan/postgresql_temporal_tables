# Cookbook to install and configure PostgreSQL 9.6 <br/>

PostgreSQL 9.6 with temporal table extension 1.2.0 cookbook covers installation and can support following Envs/OS <br/>
Onprem:   RHEL6/RHEL7/CentOS6/CentOS7 <br/>
Azure:    RHEL6/RHEL7 <br/>


##Cookbook is controlled mainly by these attributes <br/>
```ruby
default['environment'] = 'onprem' # onprem or azure
default['temporal_tables']['config'] = true
default['firewall']['config'] = false
```