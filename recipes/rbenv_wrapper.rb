
directory "#{node['boxy-rails']['data_path']}/bin" do
  recursive true
  mode '0755'
end

template "#{node['boxy-rails']['data_path']}/bin/rbenv-exec" do
  source 'rbenv/wrapper.sh.erb'
  mode '0755'
end
