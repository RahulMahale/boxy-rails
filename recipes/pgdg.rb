include_recipe 'postgresql::server'
include_recipe 'postgresql::contrib'

execute "create #{node['boxy-rails']['deployer']} user for pg" do
  user 'postgres'
  command "createuser #{node['boxy-rails']['deployer']} -d -i"
  not_if %(psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{node['boxy-rails']['deployer']}'" | grep -q 1)
end

if platform_family?('rhel') && node['postgresql']['enable_pgdg_yum']
  link "/usr/bin/pg_config" do
    to "/usr/pgsql-#{node['postgresql']['version']}/bin/pg_config"
  end
end
