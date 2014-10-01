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

# Ubuntu installs postgresql in a broken way. We want
# template1 to be UTF-8. This changes the template without
# blowing away the existing servers, and will ensure template1
# is UTF-8 on non-Ubuntu systems
# https://gist.github.com/anandology/5949798

execute "psql template1 -c \"UPDATE pg_database SET datallowconn = TRUE WHERE datname='template0'\"" do
  user 'postgres'
end

execute "psql template0 -c \"UPDATE pg_database SET datistemplate = FALSE WHERE datname='template1'\"" do
  user 'postgres'
end

execute "dropdb template1" do
  user 'postgres'
end

execute "createdb template1 -T template0 -E utf-8" do
  user 'postgres'
end

execute "psql template0 -c \"UPDATE pg_database SET datistemplate = TRUE WHERE datname='template1'\"" do
  user 'postgres'
end

execute "psql template1 -c \"UPDATE pg_database SET datallowconn = FALSE WHERE datname='template0'\"" do
  user 'postgres'
end

# Use Postgresql tools directly to create superusers
execute "createuser -s vagrant -U postgres"
execute "createuser -s #{postgresql['username']} -U postgres"

# TODO: this would have to be written for production
if false
# Wrap this in a "if dev" mode or something
postgresql_database_user 'vagrant' do
  Chef::Log.info("Creating PostgreSQL user: vagrant")
  connection admin_credentials

  password   'vagrant'
  action     :create
end
postgresql_database_user 'vagrant' do
  Chef::Log.info("Granting superuser privs: vagrant")
  connection admin_credentials
  password   postgresql['password']
  action     :grant
end

postgresql_database_user postgresql['username'] do
  Chef::Log.info("Creating PostgreSQL user: #{postgresql['username']}")
  connection admin_credentials
  password   postgresql['password']
  action     :create
end

postgresql_database_user postgresql['username'] do
  Chef::Log.info("Granting superuser privs: #{postgresql['username']}")
  connection admin_credentials
  password   postgresql['password']
  action     :grant
end
end

# Development database
postgresql_database postgresql['development_name'] do
  Chef::Log.info("Creating PostgreSQL Database: #{postgresql['development_name']}")
  connection admin_credentials

  owner      postgresql['username']
  encoding   postgresql['encoding']
  template   postgresql['template']
  action     :create
end

postgresql_database postgresql['test_name'] do
  Chef::Log.info("Creating PostgreSQL Database: #{postgresql['test_name']}")
  connection admin_credentials

  owner      postgresql['username']
  encoding   postgresql['encoding']
  template   postgresql['template']
  action     :create
end



