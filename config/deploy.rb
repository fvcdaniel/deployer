# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'deployer'
#set :repo_url, 'git@example.com:me/my_repo.git'
set :repo_url, 'ssh://ruby@201.18.100.70:2270/~/repos/production.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
 set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :tomcat do

  desc "Uploads CHANGELOG.txt to all remote servers."
  task :upload_teste do |host|
    on roles(:all), in: :sequence, wait: 5 do |server|
      upload! "/home/daniel/Documents/#{server.properties.my_property}", "/tmp/deployer"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end

  task :start do |host|
    on roles(:all), in: :sequence, wait: 1 do |server|
      execute "/etc/init.d/tomcat start"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end

  task :stop do |host|
    on roles(:all), in: :sequence, wait: 1 do |server|
      execute "/etc/init.d/tomcat stop"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end

  task :status do |host|
    on roles(:all), in: :sequence, wait: 1 do |server|
      execute "/etc/init.d/#{server.properties.tipo} status"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end

  task :restart do |host|
    on roles(:all), in: :sequence, wait: 1 do |server|
      execute "/etc/init.d/tomcat restart"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end

  task :deploy, :file do |host|
    file = "./public#{ENV['FILE']}"
    path = ENV['DPATH']
    on roles(:all), in: :sequence, wait: 1 do |server|
      
      upload! file, path
      #execute "#{server.properties.command}"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end  

  task :undeploy do |host|
    on roles(:all), in: :sequence, wait: 1 do |server|
      execute "rm -rf #{ENV['DPATH']}#{ENV['FILE']}"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end

  task :common do |host|
    on roles(:all), in: :sequence, wait: 1 do |server|
      execute "#{server.properties.command}"
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end

end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      #run "export \"https_proxy='http://200.164.109.31:3128'\""
    end
  end

  after :deploy, 'process_assets' do
    
      on roles(:app), in: :sequence do

        within release_path do
          execute :rake, 'assets:clean'
          execute :rake, 'assets:precompile'
          #execute :rake, 'db:migrate'
        end
        #run "cd #{deploy_to}/current && bundle exec rake assets:precompile:all"
        #run "cp #{deploy_to}/shared/database.yml #{current_path}/config/"
        #run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake db:migrate"
        #run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake assets:precompile"
      end
    
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
      execute "cp /var/.ruby/application.yml /var/www/current/config/"
      execute "/opt/nginx/sbin/nginx -s stop"
      execute "/opt/nginx/sbin/nginx"
    end
  end

end
