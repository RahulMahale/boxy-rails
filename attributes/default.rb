# secret to read encrypted data_bags needs to transfered to VM while bootstrapping
# Update the secret_file path as per your bootstrap process
case node['platform_family']
when "debian"
  default['boxy-rails']['secret_key_path'] = "/home/ubuntu/chef-solo/data_bag_key"
  default['deploy_app']['deploy_user'] = "ubuntu"
  default['deploy_app']['deploy_user_home'] = "/home/ubuntu"
when "rhel"
  default['boxy-rails']['secret_key_path'] = "/root/chef-solo/data_bag_key"
  default['deploy_app']['deploy_user'] = "root"
  default['deploy_app']['deploy_user_home'] = "/root"
end


default['boxy-rails']['data_path']        = '/data'
default['boxy-rails']['apps_path']        = "#{node['boxy-rails']['data_path']}/apps"
default['boxy-rails']['deployer']         = 'deployer'
default['boxy-rails']['applications']     = Array.new
default['boxy-rails']['packages']         = Array.new
default['boxy-rails']['monitor_services'] = {nginx: true, memcached: true, postgresql: true, drives_space: true}
default['boxy-rails']['monit']['drives'] = { rootfs: { path: '/', space_limit: '80%' } }
default['boxy-rails']['monit']['raw_configs'] = { }

default[:ruby][:version] = '2.2.2'

default[:rbenv][:install_prefix] = node['boxy-rails']['data_path']
default[:rbenv][:root_path]      = "#{node[:rbenv][:install_prefix]}/rbenv"
default[:rbenv][:user]           = node['boxy-rails']['deployer']
default[:rbenv][:group]          = node['boxy-rails']['deployer']
default[:rbenv][:user_home]      = "/home/#{node['boxy-rails']['deployer']}"

default['boxy-rails'][:pg_distinct_clients] = false

# Postgresql values
default['postgresql']['version'] = '9.3'
default['postgresql']['config']['port'] = 5432
default['postgresql']['config']['ssl'] = false

# NOTICE: You should provide one of those values in the node settings to use latest Postgresql 9.2.
#default['postgresql']['enable_pgdg_yum'] = true
#default['postgresql']['enable_pgdg_apt'] = true

default['postgresql']['pg_hba'] = [
  { type: 'local', db: 'all', user: node['boxy-rails']['deployer'], addr: nil,            method: 'peer'},
  { type: 'host',  db: 'all', user: node['boxy-rails']['deployer'], addr: '127.0.0.1/32', method: 'trust'},
  { type: 'host',  db: 'all', user: node['boxy-rails']['deployer'], addr: '::1/128',      method: 'trust'},
  { type: 'host',  db: 'all', user: 'all', addr: '127.0.0.1/32', method: 'md5'},
  { type: 'host',  db: 'all', user: 'all', addr: '::1/128', method: 'md5'}
]

# Sudoers
default[:authorization][:sudo][:include_sudoers_d] = true

default['nginx']['default_site_enabled'] = false
default['nodejs']['install_method'] = 'package'

# Memcached values
default['memcached']['listen'] = 'localhost'

# WARNING: This value is not from the origianl memchached value and required for monit config only
case node['platform_family']
when 'rhel', 'fedora', 'centos'
  default['memcached']['pid'] = '/var/run/memcached/memcached.pid'
  default['postgresql']['pidfile'] = "/var/run/postgresql-#{node['postgresql']['version']}.pid"
when 'ubuntu', 'debian'
  default['memcached']['pid'] = '/var/run/memcached.pid'
  default['postgresql']['pidfile'] = node['postgresql']['config']['external_pid_file'] || "/var/run/postgresql/#{node['postgresql']['version']}-main.pid"
end
