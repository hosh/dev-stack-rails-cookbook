
default['dev-stack']['app']['root_dir'] = '/vagrant'
default['dev-stack']['app']['fqdn'] = 'rails.dev'

# This is used in the upstream in the nginx config. It assumes the default Rails port of 4000
default['dev-stack']['nginx']['rails_upstream'] = 'localhost:3000'

# If you are using unicorn, then you need to set it to something like
# You don't need to uncomment this. Set this in the Vagrantfile to override
# the default.
# default['dev-stack']['nginx']['rails_upstream'] = "unix:/vagrant/tmp/sockets/unicorn.sock"

default['dev-stack']['ruby']['version'] = '1.9.3-p547'

# For building or caching datasets
default['dev-stack']['cache_dir'] = '/vagrant/.vagrant/cache'

default['dev-stack']['rails']['postgresql']['development_name']   = 'dev-stack-development'
default['dev-stack']['rails']['postgresql']['test_name']          = 'dev-stack-test'
default['dev-stack']['rails']['postgresql']['username'] = 'vagrant'
default['dev-stack']['rails']['postgresql']['password'] = 'vagrant'
default['dev-stack']['rails']['postgresql']['template'] = 'template0'
default['dev-stack']['rails']['postgresql']['encoding'] = 'UTF8'
