#
# Cookbook:: kubernetes
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'
ChefSpec::Coverage.start!

describe 'kubernetes::default' do
  context 'When all attributes are default, on an Centos 7' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.3.1611')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    # all servers
  #it 'adds docker yum repo'
    it 'installs kubernetes'
    it 'installs etcd'
    it 'installs flannel'
    it 'insert master and minions in /etc/hosts'
    it 'edits /etc/kubernetes/config'
    it 'disables firewall and selinux'

    # master
    it 'configures /etc/etcd/etcd.conf'
    it 'configures /etc/kubernetes/apiserver'
    it 'start etcd and run etcdctl commands to configure network'
    it 'configures flannel'
    it 'start etcd service'
    it 'start kube-apiserver'
    it 'start kube-controller-manager'
    it 'start kube-scheduler'
    it 'start flanneld'

    # nodes
    it 'configures kubelet /etc/kubernetes/kubelet'
    it 'configures flannel /etc/sysconfig/flanneld'
    it 'start kube-proxy'
    it 'start kubelet'
    it 'start flanneld'
    it 'start docker'
    it 'configure kubectl'

  end
end
