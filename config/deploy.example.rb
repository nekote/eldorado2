load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :repository, 'git://github.com/trevorturk/el-dorado.git'
set :scm, :git
set :deploy_via, :copy
set :git_shallow_clone, 1

set :application, 'eldorado'
set :deploy_to, '/home/eldorado'
set :mongrel_port, '8000'

role :app, "000.00.00.000"
role :web, "000.00.00.000"
role :db,  "000.00.00.000", :primary => true

before  'deploy:update_code', 'deploy:web:disable'
after   'deploy:update_code', 'deploy:config_database'
after   'deploy:update_code', 'deploy:create_symlinks'
after   'deploy:restart', 'deploy:web:enable'

namespace :deploy do
  task :restart do
    begin run "/var/lib/gems/1.8/bin/mongrel_rails stop -P #{shared_path}/log/mongrel.#{mongrel_port}.pid"; rescue; end; sleep 15;
    begin run "/var/lib/gems/1.8/bin/mongrel_rails start -d -e production -p #{mongrel_port} -P log/mongrel.#{mongrel_port}.pid -c #{release_path} --user root --group root"; rescue; end; sleep 15;
  end
  task :config_database do
    put(File.read('config/database.yml'), "#{release_path}/config/database.yml", :mode => 0444)
    # For security consider uploading a production-only database.yml to your server and using this instead:
    # run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  task :create_symlinks do
    require 'yaml'
    download "#{release_path}/config/symlinks.yml", "/tmp/eldorado_symlinks.yml"
    YAML.load_file('/tmp/eldorado_symlinks.yml').each do |share|
      run "rm -rf #{release_path}/public/#{share}"
      run "mkdir -p #{shared_path}/system/#{share}"
      run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
    end
  end
end