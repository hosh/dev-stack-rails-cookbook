#
# Cookbook Name:: dev-stack-rails
# Recipe:: postgresql
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
include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

# The PostgreSQL admin password is automatically created in the server cookbook
admin_password = node['postgresql']['password']['postgres']

admin_credentials = {
  :username => 'postgres',
  :password => admin_password
}

Chef::Log.info('Setting up PostgreSQL for Rails')

postgresql = node['dev-stack']['rails']['postgresql']

postgresql_database_user postgresql['username'] do
  Chef::Log.info("Creating PostgreSQL user: #{postgresql['username']}")
  connection admin_credentials

  password   postgresql['password']
  action     :create
end

postgresql_database postgresql['dbname'] do
  Chef::Log.info("Creating PostgreSQL Database: #{postgresql['dbname']}")
  connection admin_credentials

  owner      postgresql['username']
  encoding   postgresql['encoding']
  template   postgresql['template']
  action     :create
end


