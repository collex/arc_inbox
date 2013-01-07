# To deploy:
# cap production

require 'bundler/capistrano'
#require "delayed/recipes"
#require "whenever/capistrano"

set :application, "Arc Inbox"
set :repository, "git://github.com/collex/arc_inbox.git"
set :scm, "git"

set :deploy_to, "/home/arc/www/arc_inbox"

set :user, "arc"
set :use_sudo, false

set :normalize_asset_timestamps, false

set :ruby, "ruby-1.9.3-p0"
set :rails_env, "production"

#set :whenever_command, "bundle exec whenever"

set :default_environment, {
	'PATH' => "/home/arc/.rvm/gems/#{ruby}/bin:/home/#{user}/.rvm/gems/#{ruby}@global/bin:/home/#{user}/.rvm/rubies/#{ruby}/bin:/home/#{user}/.rvm/bin:$PATH",
	'RUBY_VERSION' => "#{ruby}",
	'GEM_HOME'     => "/home/#{user}/.rvm/gems/#{ruby}",
	'GEM_PATH'     => "/home/#{user}/.rvm/gems/#{ruby}",
	'BUNDLE_PATH'  => "/home/#{user}/.rvm/gems/#{ruby}"
}

desc "Run tasks in production environment."
task :production do
	set :branch, "master"
	set :deploy_via, :remote_cache

	role :web, "inbox.collex.org"                          # Your HTTP server, Apache/etc
	role :app, "inbox.collex.org"                          # This may be the same as your `Web` server
	role :db,  "inbox.collex.org", :primary => true 		# This is where Rails migrations will run
end

after "production", 'deploy'

after "deploy:assets:symlink" do
	# These files aren't in git, so initially they need to be manually created in the shared directory.
	run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	run "ln -nfs #{shared_path}/config/site.yml #{release_path}/config/site.yml"
	run "ln -fs #{shared_path}/uploads #{release_path}/uploads"
end

after "deploy", "deploy:migrate"

#after "deploy:stop",    "delayed_job:stop"
#after "deploy:start",   "delayed_job:start"
#after "deploy:restart", "delayed_job:restart"
