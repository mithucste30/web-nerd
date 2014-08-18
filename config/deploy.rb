SSHKit.config.command_map[:rake] = "bundle exec rake"
lock '3.2.1'

set :application, 'web-nerd'
set :scm, :git
set :repo_url, 'git@github.com:mithucste30/web-nerd.git'

server '104.131.220.188',
       :user => 'deploy',
       :roles => %w{web app db}

set :rvm_roles, [:app, :web]
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.2'
set :rvm_path, '/home/deploy/.rvm'

set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :deploy_via, :remote_cache

set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  before 'assets:precompile', 'cleanup_assets'
  after :publishing, :restart
  after :finishing, 'deploy:cleanup'


  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'tmp:cache:clear'
      end
    end
  end
end