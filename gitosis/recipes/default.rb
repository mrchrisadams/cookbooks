#
# Cookbook Name:: gitosis
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

include_recipe "git"

package "python-setuptools"

execute "clone gitosis" do
  command "git clone git://eagain.net/gitosis.git /tmp/gitosis"
  not_if { File.exists?("/home/git") }
end

execute "install gitosis" do
  command "cd /tmp/gitosis && python setup.py install"
  not_if { File.exists?("/home/git") }
end

user "git" do
  comment "Gitosis version control user"
  uid "1000"
  gid "git"
  home "/srv/git"
  shell "/bin/sh"
  password "$1$xBeHKKwZ$eFNZC1BwIK..NSXmoCgbh/"
end
