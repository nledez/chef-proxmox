#
# Cookbook Name:: proxmox
# Recipe:: fw
#
# Copyright 2013, ReHost
#
# All rights reserved - Do Not Redistribute
#

package 'shorewall'

%w{
  interfaces masq modules
  policy shorewall shorewall.conf zones
  macro.MySSH macro.Nagios macro.Proxmox
  }.each do |filename|
  cookbook_file "/etc/shorewall/#{ filename }" do
    source "shorewall/#{filename}"
    owner 'root'
    group 'root'
    mode '0444'
  end
end

cookbook_file "/etc/default/shorewall" do
  source "shorewall/shorewall"
  owner 'root'
  group 'root'
  mode '0444'
end

%w{ params routestopped rules }.each do |filename|
  template "/etc/shorewall/#{ filename }" do
    source "#{filename}.erb"
    owner 'root'
    group 'root'
    mode '0444'
    variables({
      :vz_network    => node['proxmox']['network']['vz'],
      :ip_admin      => node['proxmox']['ip']['admin'],
      :ip_root       => node['proxmox']['ip']['root'],
      :ip_staging    => node['proxmox']['ip']['staging'],
      :ip_production => node['proxmox']['ip']['production'],
    })
  end
end

%w{ root staging production vm }.each do |directory|
  directory "/etc/shorewall/rules.d.#{directory}" do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

service 'shorewall' do
  supports :restart => true
  action [:enable, :start]
end
