# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "toster"
set :repo_url, "git@github.com:dudintv/toster.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/toster"

# Default value for :linked_files is []
append :linked_files, '.env.production', 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads", "node_modules", "client/node_modules"

set :rvm_type, :user
set :rvm_ruby_version, '2.4.1'

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v9.3.0'
set :nvm_map_bins, %w{node npm yarn}

set :yarn_target_path, -> { release_path.join('client') } #
set :yarn_flags, '--production --silent --no-progress'    # default
set :yarn_roles, :all                                     # default
set :yarn_env_variables, {}

set :passenger_restart_with_touch, true

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
