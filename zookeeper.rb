include_recipe 'java'

fqdn = "#{node.name}.#{node['ageromobile_base']['int_domain']}"

if node['ec2']
  ip_address = node['ec2']['local_ipv4']
else
  ip_address = node['ipaddress']
end
zookeepers = "zk://#{ip_address}:2181/mesos"


file 'etc/yum.repos.d/mesosphere.repo' do
  source "mesosphere.repo"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end



file 'etc/mesos/zk' do
  content "zk://#{ip_address}:2181/mesos"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :restart, 'service[mesos-master]', :delayed
end


file 'etc/zookeeper/conf/myid' do
  content "1"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :restart, 'service[mesos-master]', :delayed
end

package 'mesosphere-zookeeper'
service 'zookeeper' do
  action [:enable, :start]
end


template '/etc/zookeeper/conf/zoo.cfg' do
  source 'zoo.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :restart, 'service[zookeeper]', :delayed
end