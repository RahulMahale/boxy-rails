#  app_path         = "#{node['boxy-rails']['apps_path']}/#{application['name']}"
package 'wget' do
  action :install
end

package 'installing xz' do
case node[:platform]	
  when 'redhat', 'centos'
    package_name 'xz'
  when 'ubuntu', 'debian'
    package_name 'xz-utils'
end
end 
    
bash 'Installing Wkhtmltopdf' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
	wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
	unxz wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
        tar -xvf wkhtmltox-0.12.3_linux-generic-amd64.tar
	cp wkhtmltox/bin/wkhtmltopdf /opt/ 
  EOH
end
