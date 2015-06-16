general_packages = case node['platform_family']
                   when 'debian', 'ubuntu'
                     include_recipe 'apt'
                     %w(libreadline6 libreadline6-dev git autoconf libssl-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libpq-dev libffi-dev)
                   when 'rhel'
                     include_recipe 'yum-epel'
                     package 'yum-plugin-versionlock'
                     package 'openssl-devel'

                     execute 'yum versionlock openssl-devel' do
                       not_if 'grep "openssl-devel-1.0.0-27.el6_4.2" /etc/yum/pluginconf.d/versionlock.list'
                     end

                     %w(git readline readline-devel zlib-devel gcc curl-devel httpd-devel apr-devel apr-util-devel sqlite-devel libxml2-devel libxslt-devel libffi-devel yum-utils)
                   else
                     raise node['platform_family']
                   end

general_packages.each do |pack|
  package pack do
    action :install
  end
end

if platform_family?('rhel')
  execute 'yum-config-manager --enable *server-optional* && yum makecache all' do
    only_if 'yum repolist disabled | grep -q server-optional'
  end
end

node['boxy-rails']['packages'].each do |pack|
  package pack do
    action :install
  end
end

# Nodejs
include_recipe 'nodejs'

# Imagemagick tools
include_recipe 'imagemagick::devel'

# Logrotate
include_recipe 'logrotate::default'

# Monit
include_recipe 'boxy-rails::monit'
