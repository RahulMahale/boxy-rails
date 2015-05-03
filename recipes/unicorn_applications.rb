#include_recipe 'unicorn'

node['boxy-rails'][:applications].each_with_index do |application, i|
  next if application['name'] == 'example'

  app_path     = "#{node['boxy-rails']['apps_path']}/#{application['name']}/current"
  shared_path  = "#{node['boxy-rails']['apps_path']}/#{application['name']}/shared"
  app_log_path = "#{shared_path}/log"
  app_tmp_path = "#{shared_path}/tmp"

  # Web server Unicorn
  unicorn_monit_config application['name'] do
    rails_env application['rails_env']
    app_path  app_path
    tmp_path  app_tmp_path
    worker_name "#{application[:name]}_app"
    totalmem application[:unicorn_totalmem]
  end

end
