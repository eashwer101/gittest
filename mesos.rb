if node['ec2']
  ip_address = node['ec2']['local_ipv4']
else
  ip_address = node['ipaddress']
end

execute 'Install packages for mesos, chronos, marathon' do
command 'sudo rpm -Uvh http://repos.mesosphere.com/el/6/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm'
end

package 'mesos'
package 'marathon'
package 'chronos'

file 'etc/mesos-master/ip' do
  content "#{ip_address}"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

file 'etc/mesos-master/hostname' do
  content "#{ip_address}"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

file 'etc/mesos-master/quorum' do
  content "1"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service 'mesos-master' do
  provider   Chef::Provider::Service::Upstart
  supports   status: true, restart: true
  subscribes :stop,
  subscribes :start, 'template[marathon-init]'
  action     [:enable, :start]
end

