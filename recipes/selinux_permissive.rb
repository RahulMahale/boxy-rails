if platform_family?('rhel')
  selinux_state 'SELinux Permissive' do
    action :permissive
  end
end
