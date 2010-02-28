#
# Cookbook Name:: mindtouch
# Recipe:: default
#
# Copyright 2010, Chris Adams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# the conditional not_if trick comes from Damm (http://github.com/damm) 
 # https://gist.github.com/58e8cc918e698787a065

%w{mindtouch mono}.each do |repo|
  template "/etc/yum.repos.d/#{repo}" do
    source "#{repo}.erb"
    mode 0755
    owner "root"
    group "root"
    not_if { File.exists?("/etc/yum.repos.d/#{repo}" }
  end
end  

# mono-complete needs to be installed first, otherwise yum doesn't know where to instal the other packages
package "mono-complete"

%w{wv elinks poppler poppler-utils tidy html2ps}.each do |pkg|
  package pkg
end

remote_file "/tmp/prince-6.0r6-linux.tar.gz" do
  source "http://www.princexml.com/download/prince-6.0r6-linux.tar.gz"
  not_if { File.exists?("/etc/httpd/conf.d/deki-apache.conf") }
end

execute "extract_prince" do
  command "cd /tmp && tar xfzv prince-6.0r6-linux.tar.gz"
  creates "/tmp/prince-6.0r6-linux"
  not_if { File.exists?("/etc/httpd/conf.d/deki-apache.conf") }
end

file "/tmp/prince-6.0r6-linux/install.sh" do
  action :delete
  not_if { File.exists?("/etc/httpd/conf.d/deki-apache.conf") }
end

template "/tmp/prince-6.0r6-linux/install.sh" do
  source "install.sh.erb"
  mode 0755
  owner "root"
  group "root"
  not_if { File.exists?("/etc/httpd/conf.d/deki-apache.conf") }
end

execute "install_prince" do
  command "cd /tmp/prince-6.0r6-linux && ./install.sh"
  not_if { File.exists?("/etc/httpd/conf.d/deki-apache.conf") }
end

package "dekiwiki"

template "/etc/httpd/conf.d/deki-apache.conf" do
  source "deki-apache.conf.erb"
  mode 0755
  owner "root"
  group "root"
end

execute "import root certs from mozilla" do
  command "mozroots --import --sync"
  not_if { File.exists?("/etc/httpd/conf.d/deki-apache.conf") }
end

execute "service httpd restart" do
  command "service httpd restart"
end

execute "service httpd restart" do
  command "service mysqld restart"
end

# this takes all the commands listed on the final page, and 
# puts them into a single bash script to call after installation
template "/tmp/finish-installing-mindtouch.sh"
  source "finish-installing-mindtouch.sh"
  mode 0755
  owner "root"
  owner "root"
end
