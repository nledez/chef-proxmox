#
# Cookbook Name:: rehost-proxmox
# Recipe:: default
#
# Copyright 2013, ReHost
#
# All rights reserved - Do Not Redistribute
#

default['proxmox']['packages-stage1'] = %w{pve-firmware pve-kernel-2.6.32-23-pve pve-headers-2.6.32-23-pve}
default['proxmox']['packages'] = %w{proxmox-ve-2.6.32 ksm-control-daemon vzprocps}
