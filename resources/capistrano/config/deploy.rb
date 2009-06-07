# require multistage plugin
require 'capistrano/ext/multistage'

set :application, "APPLICATIE"
set :user, "USER"
set :repository,  "REPOSITORY"
set :deploy_to, "/usr/local/wwwroot/#{application}"
set :deploy_via, "remote_cache"

ssh_options[:forward_agent] = true
ssh_options[:username] = "SSHUSER"
set :use_sudo, false

set :default_stage, "production"
set :stages, %w(production staging)

namespace :deploy do

  # launch the following task after updating the code
  after "deploy:update_code", "deploy:link_settings"

  desc "Link the settings file to the release directory"
  task :link_settings do
    run "ln -nfs #{deploy_to}/shared/xsettings/settings.php #{release_path}/xsettings/settings.php"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is not necessary with PHP"
    task t, :roles => :app do ; end
  end
end
