#
# Cookbook:: postgresql
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe "#{node['cookbook']['name']}::onprem" if (%w(redhat centos).include?(node['platform'])) && (node['environment'].eql? "onprem")
include_recipe "#{node['cookbook']['name']}::azure"  if (%w(redhat centos).include?(node['platform'])) && (node['environment'].eql? "azure")

# Checking for config attribute before configuring the firewall

include_recipe "#{node['cookbook']['name']}::firewall" if (node['firewall']['config'].eql? true) && (node['environment'].eql? "onprem")