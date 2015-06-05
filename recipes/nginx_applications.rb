# Nginx
include_recipe 'nginx'

node['boxy-rails'][:applications].each_with_index do |application, i|
  next if application['name'] == 'example'

  app_path         = "#{node['boxy-rails']['apps_path']}/#{application['name']}/current"
  shared_path      = "#{node['boxy-rails']['apps_path']}/#{application['name']}/shared"
  app_log_path     = "#{shared_path}/log"
  app_tmp_path     = "#{shared_path}/tmp"
  custom_locations = application['custom_locations'] || []
  custom_upstreams = application['custom_upstreams'] || []
  domain           = application['domain'] ? application['domain'].gsub(/[^a-zA-Z.]/, '.') : nil

  # Nginx site
  template "#{node['nginx']['dir']}/sites-available/#{application['name']}" do
    source 'nginx/default.conf.erb'
    notifies :reload, 'service[nginx]'
    variables name: application['name'],
              app_path: app_path,
              log_path: app_log_path,
              tmp_path: app_tmp_path,
              ssl_redirect: application['ssl_redirect'],
              ssl: application['ssl'],
              domain: domain,
              custom_locations: custom_locations,
              custom_upstreams: custom_upstreams
  end

  nginx_site application['name']
end
