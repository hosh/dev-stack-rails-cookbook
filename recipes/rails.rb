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
include_recipe 'dev-stack-rails::libv8'

rails_root        = node['dev-stack']['app']['root_dir']
rbenv_root        = rbenv_root_path # Cache the DSL helper

# bundle install
# Cannot use rbenv_execute here because it messes up the home paths and such
execute "#{rbenv_bin_path}/rbenv exec bundle install" do
  environment({ 'HOME' => '/home/vagrant', 'RBENV_ROOT' => rbenv_root })

  cwd    rails_root
  user   'vagrant'
  group  'rbenv'

  action :run
end
