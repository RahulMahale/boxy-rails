#  app_path         = "#{node['boxy-rails']['apps_path']}/#{application['name']}"

bash 'Installing Wkhtmltopdf' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
	wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
	tar xf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
	cp wkhtmltox/bin/wkhtmltopdf /opt/ 
  EOH
end
