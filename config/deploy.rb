lock '3.2.1'

set :application, 'web-nerd'
set :repo_url, 'git@github.com:mithucste30/web-nerd.git'

server: '104.131.220.188',
  user: 'deploy',
  roles: %w{web app db},
  ssh_options: {
  keys: %w(~/.ssh/id_rsa.pub),
  forward_agent: true,
  auth_methods: %w(publickey)
}


set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

#  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do      
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

#  after :publishing, :restart
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      # Here we can do anything such as:
#      # within release_path do
#      #   execute :rake, 'cache:clear'
#      # end
#    end
#  end

end
