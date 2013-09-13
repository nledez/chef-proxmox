#
# Cookbook Name:: rehost-proxmox
# Recipe:: default
#
# Copyright 2013, ReHost
#
# All rights reserved - Do Not Redistribute
#

default['proxmox']['packages'] = [ 'pve-kernel-2.6.32-23-pve', 'pve-headers-2.6.32-23-pve', 'proxmox-ve-2.6.32', 'vzprocps' ]
