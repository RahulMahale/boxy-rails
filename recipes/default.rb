include_recipe 'boxy-rails::selinux_permissive'
# User deployer
include_recipe 'boxy-rails::user'
include_recipe 'boxy-rails::sudoers'
include_recipe 'boxy-rails::lib_directory'
include_recipe 'boxy-rails::packages'
include_recipe 'boxy-rails::wkhtml'

nclude_recipe 'boxy-rails::ruby'

# Postfix - local smtp server
include_recipe 'postfix'

# Memcached service
include_recipe 'redis'
include_recipe 'memcached'

# Postgresql
include_recipe 'boxy-rails::pgdg'

# Rails applications
include_recipe 'boxy-rails::applications'
