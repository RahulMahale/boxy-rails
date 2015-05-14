# Cookbook Name:: boxy-rails
# Recipe:: deploy_app

secret = Chef::EncryptedDataBagItem.load_secret("#{node['boxy-rails']['secret']}")
creds = Chef::EncryptedDataBagItem.load("keys", "deploy", secret)

deploy_key = "#{creds['deploy_key']}"

directory "#{node['deploy_app']['deploy_user_home']}/.ssh" do
  owner node['deploy_app']['deploy_user']
  group node['deploy_app']['deploy_user']
  mode  "0775"
end

file "#{node['deploy_app']['deploy_user_home']}/.ssh/deploy" do
  owner   node['deploy_app']['deploy_user']
  group   node['deploy_app']['deploy_user']
  mode    "0400"
  content deploy_key
end

template "#{node['deploy_app']['deploy_user_home']}/.ssh/config" do
  source  "config.erb"
  owner   node['deploy_app']['deploy_user']
  group   node['deploy_app']['deploy_user']
  mode    "0644"
  variables({
    :repo_host => "github.com",
    :keyfile => "#{node['deploy_app']['deploy_user_home']}/.ssh/deploy"
  })
end

