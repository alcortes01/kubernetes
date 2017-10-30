#
# Cookbook:: .
# Recipe:: common
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'disable selinux' do
  command 'sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/sysconfig/selinux'
  action :run
  notifies :reboot_now, 'reboot[selinux_updated]', :immediately
  not_if 'grep SELINUX=permissive /etc/sysconfig/selinux'
end

reboot 'selinux_updated' do
  action :nothing
  reason 'Need to reboot to update selinux permissive.'
end

package 'kubernetes' do
  action :install
end

template '/etc/kubernetes/config' do
  source 'config.erb'
end

# ruby_block "add master url to kubernetes config" do
#   block do
#     file = Chef::Util::FileEdit.new("/etc/kubernetes/config")
#     file.search_file_replace_line(/KUBE_MASTER=*/, "KUBE_MASTER=\"--master=#{node['kubernetes']['master_url']}\"")
#     file.write_file
#   end
# end
