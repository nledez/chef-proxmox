#
# Cookbook Name:: proxmox
# Recipe:: fw
#
# Copyright 2013, ReHost
#
# All rights reserved - Do Not Redistribute
#

package 'shorewall'

openvpn = node['recipes'].include? 'rehost-openvpn'
if openvpn
  remote = node['openvpn']['remote']
else
  remote = nil
end

%w{
  masq modules
  policy shorewall shorewall.conf zones
  macro.MySSH macro.Nagios macro.Proxmox
  shorewall-rule-template
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

cookbook_file "/usr/local/sbin/shorewall-create-rules" do
  source "shorewall/shorewall-create-rules"
  owner 'root'
  group 'root'
  mode '0555'
end

%w{ interfaces tunnels params routestopped rules }.each do |filename|
  template "/etc/shorewall/#{ filename }" do
    source "#{filename}.erb"
    owner 'root'
    group 'root'
    mode '0444'
    variables({
      :vz_network            => node['proxmox']['network']['vz'],
      :ip_admin              => node['proxmox']['ip']['admin'],
      :ip_root               => node['proxmox']['ip']['root'],
      :ip_prod               => node['proxmox']['ip']['prod'],
      :ip_prod_bck           => node['proxmox']['ip']['prod_bck'],
      :ip_staging            => node['proxmox']['ip']['staging'],
      :ip_staging_bck        => node['proxmox']['ip']['staging_bck'],
      :remote                => remote,
      :openvpn               => openvpn,
    })
  end
end

directory "/etc/shorewall/rules.d.vm" do
  owner 'root'
  group 'root'
  mode '0755'
end

%w{ root staging prod }.each do |directory|
  directory "/etc/shorewall/rules.d.#{directory}" do
    owner 'root'
    group 'root'
    mode '0755'
    only_if { node['proxmox']['ip'][directory] }
  end
end

service 'shorewall' do
  supports :restart => true
  action [:enable, :start]
end
