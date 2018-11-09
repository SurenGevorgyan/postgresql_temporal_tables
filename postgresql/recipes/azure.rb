#
# Cookbook:: postgresql
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe "#{node['cookbook']['name']}::helper"

Chef::Log.info("#{node['environment']} - selected as environment. ")
puts("#{node['environment']} - selected as environment. ")

package 'Installing PostgreSQL 96' do
    if (node['platform_version'] =~ /7./)
        package_name node['onprem']['platform_v_7']['pkg_to_install']
        notifies :run,   'execute[Database Initialization]'
        notifies :create,   "template[#{node['postgresql']['data_dir']}/postgresql.conf]"
        notifies :create,   "template[#{node['postgresql']['data_dir']}/pg_hba.conf]"
        notifies :start, "service[#{node['postgresql']['service_name']}]"
        notifies :enable, "service[#{node['postgresql']['service_name']}]"
    elsif (node['platform_version'] =~ /6./)
        package_name node['onprem']['platform_v_6']['pkg_to_install']
        notifies :run,   'execute[Database Initialization]'
        notifies :create,   "template[#{node['postgresql']['data_dir']}/postgresql.conf]"
        notifies :create,   "template[#{node['postgresql']['data_dir']}/pg_hba.conf]"
        notifies :start, "service[#{node['postgresql']['service_name']}]"
        notifies :enable, "service[#{node['postgresql']['service_name']}]"
    end
end

execute 'Database Initialization' do
    action :nothing
    command "/opt/rh/rh-postgresql96/root/usr/bin/postgresql-setup --initdb"
    only_if { ::Dir.empty?("#{node['postgresql']['data_dir']}") }
end

template "#{node['postgresql']['data_dir']}/postgresql.conf" do
    action :nothing
    source 'postgresql.conf.erb'
    variables(listen_addresses: node['postgresql']['config']['listen_addresses'])
end

template "#{node['postgresql']['data_dir']}/pg_hba.conf" do
    action :nothing
    source 'pg_hba.conf.erb'
    variables(listen_addresses: node['postgresql']['config']['listen_addresses'])
end

if node['temporal_tables']['config']
    package 'Installing temporal_tables' do
          package_name node['onprem']['temporal_tables']
    end
   
    if (node['platform_version'] =~ /7./)
    cookbook_file '/tmp/pgxnclient-1.2.1-2.rhel7.x86_64.rpm' do
      source 'pgxnclient-1.2.1-2.rhel7.x86_64.rpm'
      action :create
    end
    package 'PGXN install' do
        source '/tmp/pgxnclient-1.2.1-2.rhel7.x86_64.rpm'
        action :install
    end
    elsif (node['platform_version'] =~ /6./)
    cookbook_file '/tmp/pgxnclient-1.2.1-2.rhel6.x86_64.rpm' do
      source 'pgxnclient-1.2.1-2.rhel6.x86_64.rpm'
      action :create
    end
    package 'PGXN install' do
        source '/tmp/pgxnclient-1.2.1-2.rhel6.x86_64.rpm'
        action :install
    end

    end
    execute 'Execute Installation of Temporal Tables' do
      command 'pgxn install temporal_tables --pg_config=/opt/rh/rh-postgresql96/root/usr/bin/pg_config'
      not_if { ::File.exists?('/opt/rh/rh-postgresql96/root/usr/share/pgsql/extension/temporal_tables.control')}
      notifies :restart, "service[#{node['postgresql']['service_name']}]"
      notifies :run, 'execute[Create temporal_tables extension]'
    end

    execute 'Create temporal_tables extension' do
        action :nothing
        command 'psql -U postgres -c "CREATE EXTENSION temporal_tables;"'
    end
end