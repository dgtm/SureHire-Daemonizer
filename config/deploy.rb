require "bundler/capistrano"

set :application, "SureHire-Daemonizer"
set :repository,  "git@github.com:dgtm/SureHire-Daemonizer.git"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/home/deploy/SureHire-Daemonizer"
set :deploy_via, :copy
set :copy_strategy, :export

set :user, "deploy"  # The server's user for deploys
set :port, 2020
set :use_sudo, false

server 'results.surehire.ca', :app, :web
set :password, 'k@thmandu0977'
set :branch, 'master'

#ssh_options[:forward_agent] = true # using your own private keys for git you might want to tell Capistrano to use agent forwarding with this command
set :scm, :git
set :scm_username, 'sprout-deploy'

  namespace :customs  do
    task :tmp do
      run "cd #{current_release}; mkdir -p tmp/production/"
    end

    task :restart do
    	run "cd #{current_release}; bundle; foreverb stop --all -y"
    end
  end

after :deploy, "customs:tmp", 'customs:restart'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end