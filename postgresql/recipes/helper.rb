#
# Cookbook:: postgresql
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

service "#{node['postgresql']['service_name']}" do
  supports :status => true, :restart => true, :start => true , :enable => true
  action :nothing
end