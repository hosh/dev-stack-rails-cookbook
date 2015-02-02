#
# Cookbook Name:: dev-stack-rails
# Recipe:: ruby
#
# Copyright (C) 2013 Ho-Sheng Hsiao
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be included in all copies
# or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# Ruby 1.9.3 is a good enough default for now

Chef::Log.info "Setting up rbenv"
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

ruby_version      = node['dev-stack']['ruby']['version']
ruby_cache_dir    = node['dev-stack']['cache_dir']
ruby_cached_build = "#{ruby_cache_dir}/ruby-#{ruby_version}.tar.bz2"
rbenv_root        = "#{node['rbenv']['install_prefix']}/rbenv"
rbenv_versions    = "#{rbenv_root}/versions"

if File.exists?(ruby_cached_build)
  Chef::Log.info "Cached ruby detected #{ruby_cached_build}, skipping build"

  directory rbenv_versions do
    user      'rbenv'
    group     'rbenv'
    mode      '00755'
    recursive true
  end

  execute "tar -jxvpf #{ruby_cached_build} --same-owner" do
    cwd   rbenv_versions
    user  'root'
    group 'root'
  end
else
  Chef::Log.info "No cached build for #{ruby_version}. Building from scratch ..."
  # Build from scratch
  rbenv_ruby ruby_version

  Chef::Log.info "Caching ruby build to #{ruby_cached_build}"
  directory ruby_cache_dir do
    user      'vagrant'
    group     'vagrant'
    mode      '00755'
    recursive true
  end

  execute "tar -jcvpf #{ruby_cached_build} --same-owner #{ruby_version}" do
    cwd   rbenv_versions
    user  'root'
    group 'root'
  end
end

rbenv_gem "bundler" do
  ruby_version ruby_version
end

# Set the global version of ruby
# Use this instead of rbenv_command, since this needs
# to run during runtime
execute "#{rbenv_bin_path}/rbenv global #{ruby_version}" do
  environment({ 'HOME' => '/home/vagrant', 'RBENV_ROOT' => rbenv_root })

  cwd    rbenv_root
  user   'rbenv'
  group  'rbenv'
end

