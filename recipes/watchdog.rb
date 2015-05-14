# Cookbook Name:: boxy-rails
# Recipe:: watchdog

secret = Chef::EncryptedDataBagItem.load_secret("#{node['boxy-rails']['secret']}")
creds = Chef::EncryptedDataBagItem.load("keys", "watchdog", secret)

node.default['datadog']['api_key'] = "#{creds['api_key']}"
node.default['datadog']['application_key'] = "#{creds['app_key']}"

include_recipe "apt"
include_recipe "datadog::dd-agent"
