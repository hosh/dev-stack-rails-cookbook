
default['dev-stack']['app']['root_dir'] = '/vagrant'
default['dev-stack']['rails']['version'] = '1.9.3-p362'

# For building or caching datasets
default['dev-stack']['cache_dir'] = '/vagrant/.vagrant/cache'

default['dev-stack']['rails']['postgresql']['development_name']   = 'dev-stack-development'
default['dev-stack']['rails']['postgresql']['test_name']          = 'dev-stack-test'
default['dev-stack']['rails']['postgresql']['username'] = 'vagrant'
default['dev-stack']['rails']['postgresql']['password'] = 'vagrant'
default['dev-stack']['rails']['postgresql']['template'] = 'template1'
default['dev-stack']['rails']['postgresql']['encoding'] = 'UTF8'
