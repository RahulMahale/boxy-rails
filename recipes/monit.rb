# Cookbook Name:: boxy-rails
# Recipe:: monit

include_recipe 'postfix'
include_recipe 'monit'

if node['platform_family'] == 'rhel'
  template '/etc/monit.conf' do
    cookbook 'monit'
    owner 'root'
    group 'root'
    mode 0700
    source 'monitrc.erb'
    notifies :restart, resources(service: 'monit'), :delayed
  end
end

node['boxy-rails']['monitor_services'].each do |service_name, enabled|

  monit_action = (enabled.nil? || enabled) ? :enable : :delete
  monitrc service_name do
    action monit_action
    template_source "monit/#{service_name}.conf.erb"
    template_cookbook 'boxy-rails'
  end
end

node['boxy-rails']['monit']['raw_configs'].each do |service_name, raw_config|
  next if service_name.match(/example/)  == nil

  monit_action = (!raw_config or raw_config.empty?) ? :disable : :enable
  monitrc service_name do
    action monit_action
    template_source 'monit/raw_configs.conf.erb'
    template_cookbook 'boxy-rails'
    variables config_source: raw_config
  end
end

