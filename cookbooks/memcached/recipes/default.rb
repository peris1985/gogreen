#
# Cookbook Name:: memcached
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

package "memcached" do
	action :install
end

service "memcached" do
	action  :start
end
