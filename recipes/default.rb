#
# Cookbook Name:: proxmox
# Recipe:: default
#
# Copyright 2013, ReHost
#
# All rights reserved - Do Not Redistribute
#

file '/etc/grub.d/06_OVHkernel' do
  action :delete
end

cookbook_file '/etc/grub.d/10_linux' do
  source '10_linux'
  mode '0555'
  owner 'root'
  group 'root'
end

apt_repository 'proxmox' do
  uri 'http://download.proxmox.com/debian'
  distribution "wheezy"
  components [ "pve" ]
  key "http://download.proxmox.com/debian/key.asc"
end

node['proxmox']['packages-stage1'].each do |pkg|
  package pkg do
    action :install
  end
end

ruby_block "Check if pve kernel is running" do
  block do
    unless node['kernel']['release'] =~ /-pve$/
      Chef::Application.fatal!("Need to reboot")
    end
  end
end

node['proxmox']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end
