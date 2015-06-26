case node['platform_family']
when 'rhel'
  include_recipe 'yum-epel'
  package %w(freetds freetds-devel)
when 'debian'
  package %w(freetds-dev freetds-bin)
else
  Chef::Log.fatal("Unsupported platform family: node['platform_family']")
  fail
end
