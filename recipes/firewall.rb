#
# Cookbook:: postgresql
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

firewall 'default' do
     action :install
     enabled_zone :public
end

firewall_rule "Open ports for appliction" do
    port node['firewall']['open_ports']
end
