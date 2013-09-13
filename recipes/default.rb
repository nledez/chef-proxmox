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

apt_repository 'proxmox' do
  uri 'http://download.proxmox.com/debian'
  distribution "wheezy"
  components [ "pve" ]
  key "http://download.proxmox.com/debian/key.asc"
end

node['proxmox']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end
