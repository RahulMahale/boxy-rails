node['boxy-rails'][:applications].each_with_index do |application, i|
  next if application['name'] == 'example'

  app_path     = "#{node['boxy-rails']['apps_path']}/#{application['name']}/current"
  shared_path  = "#{node['boxy-rails']['apps_path']}/#{application['name']}/shared"
  app_log_path = "#{shared_path}/log"
  app_tmp_path = "#{shared_path}/tmp"

  # Logrotate for application
  logrotate_app application['name'] do
    cookbook  'logrotate'
    path      File.join(app_log_path, '*.log')
    frequency 'daily'
    rotate    30
    create    "644 #{node['boxy-rails']['deployer']} #{node['boxy-rails']['deployer']}"
  end
end
