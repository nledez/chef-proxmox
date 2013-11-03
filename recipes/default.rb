#
# Cookbook Name:: proxmox
# Recipe:: default
#
# Copyright 2013, ReHost
#
# All rights reserved - Do Not Redistribute
#

if node['proxmox']['lvm']
  directory "/var/lib/vz" do
    action :create
  end

  LVM = `lvs --noheadings`
  volumes = LVM.split(/\n/).map { |v| v.split(/ +/)[1] }
  unless volumes.include? 'vz'
    Chef::Log.info "Need to create vz lv"
    vg = LVM.split(/\n/).map { |v| v.split(/ +/)[2] }.uniq[0]

    bash "create-/dev/#{vg}/vz" do
      code <<-EOH
      /sbin/lvcreate -L 10G --name vz #{vg} && /sbin/mkfs.ext3 /dev/#{vg}/vz
      /bin/mv /var/lib/vz /var/lib/vz.bak ; /bin/mkdir /var/lib/vz
      EOH
    end

    mount "/var/lib/vz" do
      fstype "ext3"
      device "/dev/#{vg}/vz"
      options "defaults,noatime,nodiratime"
      action   [:mount, :enable]
    end

    bash "finish-with-/var/lib/vz.bak-move" do
      code "/bin/mv /var/lib/vz.bak/* /var/lib/vz/ ; /bin/rmdir /var/lib/vz.bak"
    end
  end
end

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
      exit 0
    end
  end
end

node['proxmox']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end
