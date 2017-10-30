# kubernetes

Chef cookbook to create a Kubernetes cluster.

Recipes:
+ common.rb to install kubernetes in all servers.
+ node.rb to configure flanneld, kube-proxy, docker, and kubelet.
+ master.rb to configure etcd, kube-proxy, kube-scheduler, kube-controller-manager, and kube-apiserver.

Requirements:
+ To test using Chef Kitchen, and Vagrant, you need to install the Landrush plugin to manage DNS automatically. Configure .kitchen.yml to add static IPs, and hostnames in the .vagrant.test domain.
+ Master server to include common and master recipes.
+ Nodes to include common and node recipes.
+ default attributes to be modified:
  - default['kubernetes']['master_url']
  - default['kubernetes']['etcd_url']
  - default['kubernetes']['api_server']
  - default['kubernetes']['ssl_key']
  - default['kubernetes']['flanneld_iface']
+ flanneld_iface = enp0s8 is the default private interface assigned by Vagrant, you will need to change this to the interface that will be used for nodes communication. E.g. eth1.
