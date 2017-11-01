#
# Cookbook:: .
# Recipe:: master
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'etcd' do
  action :install
end

template '/etc/etcd/etcd.conf' do
  source 'etcd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'etcd' do
  supports status: true
  action [:enable, :restart]
end

execute 'create etcd /kube-flannel/network' do
  command 'etcdctl mkdir /kube-flannel/network'
  action :run
  not_if 'etcdctl ls -recursive | grep /kube-flannel/network'
end

etcd_config = '{ "Network":"172.30.0.0/16", "SubnetLen":24, "Backend": { "Type": "vxlan" } }'

execute 'create etcd /kube-flannel/network/config' do
  command "etcdctl mk /kube-flannel/network/config '#{etcd_config}'"
  action :run
  not_if 'etcdctl ls -recursive | grep /kube-flannel/network/config'
end

template '/etc/sysconfig/flanneld' do
  source 'flanneld.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[restart flanneld]', :immediately
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

execute 'create service key' do
  command "openssl genrsa -out #{node['kubernetes']['ssl_key']} 2048"
  action :run
  not_if "test -f #{node['kubernetes']['ssl_key']}"
end

template '/etc/kubernetes/apiserver' do
  source 'apiserver.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[restart kube-apiserver]', :immediately
end

service 'kube-apiserver' do
  supports status: true
  action [:enable, :start]
end

service 'restart kube-apiserver' do
  service_name 'kube-apiserver'
  supports status: true
  action :nothing
end

template '/etc/kubernetes/controller-manager' do
  source 'controller-manager.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[restart kube-controller-manager]', :immediately
end

service 'enable kube-controller-manager' do
  service_name 'kube-controller-manager'
  supports status: true
  action [:enable, :start]
end

service 'restart kube-controller-manager' do
  service_name 'kube-controller-manager'
  supports status: true
  action :nothing
end

service 'kube-scheduler' do
  supports status: true
  action [:enable, :start]
end
