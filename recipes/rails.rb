#
# Cookbook Name:: dev-stack-rails
# Recipe:: rails
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
# TODO: Make this overridable for people to tweak from Vagrant or from dev-stack.json (or something)

include_recipe 'dev-stack-rails::ruby'

rails_root        = node['dev-stack']['app']['root_dir']
rbenv_root        = "#{node['rbenv']['install_prefix']}/rbenv"
rbenv_binary_path = "#{rbenv_root}/bin/rbenv"
ruby_version      = node['dev-stack']['rails']['verison']

# Make sure rbenv dotfile is in the application root.
#file "#{rails_root}/.ruby-version" do
#  owner   'vagrant'
#  group   'vagrant'
#  mode    '0755'
#  content ruby_version

#  action :create
#end

# bundle install
# We have to explicitly be running under the rbenv user
# TODO: Move this into a LWRP
execute "#{rbenv_binary_path} exec bundle install" do
  environment({ 'HOME' => '/home/vagrant', 'RBENV_ROOT' => rbenv_root })

  cwd    rails_root
  user   'rbenv'
  group  'rbenv'

  action :run
end


