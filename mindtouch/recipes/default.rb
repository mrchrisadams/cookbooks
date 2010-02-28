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

%w{a2ensite a2dissite}.each do |repo|
  template "/etc/yum.repos.d/#{repo}" do
    source "#{repo}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end  

%w{wv links pdftohtml tidy html2ps mono-complete}.each do |pkg|
  package pkg
  action :install
end

remote_file "/tmp/prince-6.0r6-linux.tar.gz" do
  source "http://www.princexml.com/download/prince-6.0r6-linux.tar.gz"
end

execute "extract_prince" do
  commmand "cd /tmp && tar xfzv prince-6.0r6-linux.tar.gz"
  creates "/tmp/prince-6.0r6-linux"
end

file "/tmp/prince-6.0r6-linux/install.sh" do
  action :delete
end

template "/tmp/prince-6.0r6-linux/install.sh" do
  source "install.sh.erb"
  mode 0755
  owner "root"
  group "root"
end

execute "install_prince" do
  command "cd /tmp/prince-6.0r6-linux && ./install.sh"
end

package "dekiwiki"

template "/etc/httpd/conf.d/deki-apache.conf" do
  source "deki-apache.conf.erb"
  mode 0755
  owner "root"
  group "root"
end

execute "import root certs from mozilla" do
  commmand "mozroots --import --sync"
end

execute "service httpd restart" do
  command "service httpd restart"
end

execute "service httpd restart" do
  command "service mysqld restart"
end



