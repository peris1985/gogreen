#
# Cookbook Name:: source-memcached
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package ["libevent", "make", "gcc"] do
action :install
end

cookbook_file "#{Chef::Config[:file_cache_path]}/libevent-2.0.22-stable.tar.gz" do
 source "libevent-2.0.22-stable.tar.gz"
end

bash "compile_libevent_source" do
cwd Chef::Config[:file_cache_path]
code <<-EOH
 tar zxf libevent-2.0.22-stable.tar.gz
 cd libevent-2.0.22-stable
 ./configure && make && make install
 EOH
creates "/usr/local/bin/libevent.so"
end
# action :nothing
# creates "/usr/local/bin/memcached"
# end

cookbook_file "#{Chef::Config[:file_cache_path]}/memcached-1.4.25.tar.gz" do
 source "memcached-1.4.25.tar.gz"
end

bash "compile_memcached_source" do
cwd Chef::Config[:file_cache_path] 
code <<-EOH
 tar zxf memcached-1.4.25.tar.gz
 cd memcached-1.4.25
 ./configure && make && make install
 EOH
# action :nothing
creates "/usr/local/bin/memcached"
end

service "memcached" do
provider Chef::Provider::Service::Init::Redhat
subscribes :restart, resources(:bash => "compile_memcached_source")
supports status: true, start: true, stop: true, restart: true, enable: true
end

service "memcached" do
  supports status: true, start: true, stop: true, restart: true, enable: true
action  :nothing
end

template "memcached" do
  path "/etc/init.d/memcached"
  source "memcached.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[memcached]"
  notifies :start, "service[memcached]"
end
# service "memcached" do
#  action  :start
#  supports status: true, start: true, stop: true, restart: true, enable: true
#end

template '/etc/memcached.conf' do
    source 'memcached.conf.erb'
    owner  'root'
    group  'root'
    mode   '0644'
#    variables(
#      listen: node['memcached']['listen'],
#      user: 'root',
#      port: node['memcached']['port'],
#      udp_port: node['memcached']['udp_port'],
#      maxconn: node['memcached']['maxconn'],
#      memory: node['memcached']['memory'],
#      logfilepath: node['memcached']['logfilepath'],
#      logfilename: node['memcached']['logfilename'],
#      threads: node['memcached']['threads'],
#      max_object_size: node['memcached']['max_object_size'],
#      experimental_options: Array(node['memcached']['experimental_options'])
#    )
    notifies :restart, 'service[memcached]'
  end

service "memcached" do
action  :start
#  action [:enable, :start]
  supports status: true, start: true, stop: true, restart: true, enable: true
end
