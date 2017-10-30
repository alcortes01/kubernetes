#
# Cookbook:: .
# Recipe:: node
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'flannel' do
  action :install
end

template '/etc/kubernetes/kubelet' do
  source 'kubelet.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[restart kube-proxy]', :immediately
  notifies :restart, 'service[restart kubelet]', :immediately
end

template '/etc/sysconfig/flanneld' do
  source 'flanneld.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[restart flanneld]', :immediately
  notifies :restart, 'service[restart docker]', :immediately
end

service 'kube-proxy' do
  supports status: true
  action [:enable, :start]
end

service 'restart kube-proxy' do
  service_name 'kube-proxy'
  supports status: true
  action :nothing
end

service 'kubelet' do
  supports status: true
  action [:enable, :start]
end

service 'restart kubelet' do
  service_name 'kubelet'
  supports status: true
  action :nothing
end

service 'docker' do
  supports status: true
  action [:enable, :start]
end

service 'flanneld' do
  supports status: true
  action [:enable, :start]
end

service 'restart flanneld' do
  service_name 'flanneld'
  supports status: true
  action :nothing
end

service 'restart docker' do
  service_name 'docker'
  supports status: true
  action :nothing
end
