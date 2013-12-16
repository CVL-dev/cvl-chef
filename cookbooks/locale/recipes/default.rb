#
# Cookbook Name:: locale
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
# Copyright 2013, The University of Queensland
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

if platform?("ubuntu", "debian")
  package "locales" do
    action :install
  end
end

locale_settings = node['locale'].to_hash()

if locale_settings['lang'] == nil 
  current_lang = MixLib::ShellOut.new(
          'expr `locale | grep LANG=` : ^LANG=(.*)$').run_command().stdout
  Chef::Log.warn("current_lang is #{current_lang}")
  locale_settings['lang'] = current_lang || "en_US.utf8"
end

# Some applications depend on these locale variables ... so default them
if locale_settings['lc_all'] == nil 
  locale_settings['lc_all'] = locale_settings['lang']
end
if locale_settings['language'] == nil 
  locale_settings['language'] = locale_settings['lang']
end

# Check the locale names are known
ruby_block "check locales" do
  block do
    locale_settings.each() do |key, value|
      cmd = MixLib::ShellOut.new("locale -a | grep ^#{value}$").run_command
      unless cmd.exitstatus == 0 
        Chef::Log.warn("The requested locale '#{value}' is not known or not installed")
      end
    end
  end
end

if platform?("ubuntu", "debian")
  locale_settings.each() do |key, value|
    execute "Update locale" do
      command "update-locale #{key.upcase}=#{value}"
    end
  end
end

if platform?("redhat", "centos", "fedora")
  locale_settings.each() do |key, value|
    execute "Update locale" do
      command "sed -i 's|#{key.upcase}=.*|#{key.upcase}=#{value}|' /etc/sysconfig/i18n"
    end
  end
end

