include_recipe 'boxy-rails::nginx_applications'
include_recipe 'boxy-rails::unicorn_applications'
include_recipe 'boxy-rails::delayed_job_applications'
include_recipe 'boxy-rails::logrotate_applications'
