fqdn = "#{node.name}.#{node['ageromobile_base']['int_domain']}"

if node['ec2']
  ip_address = node['ec2']['local_ipv4']
else
  ip_address = node['ipaddress']
end

directory '/etc/marathon/conf' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'Define hostname' do
command 'cp /etc/mesos-master/hostname /etc/marathon/conf'
end

execute 'Define zookeeper for marathon' do
command 'cp /etc/mesos/zk /etc/marathon/conf/master'
end

file '/etc/marathon/conf/zk' do
  content "zk://#{ip_address}:2181/marathon"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :restart, 'service[marathon]', :delayed
end

service 'marathon' do
  provider   Chef::Provider::Service::Upstart
  supports   status: true, restart: true
  subscribes :stop, 
  subscribes :start,
  action     [:enable, :start]
end



