# config/puma.rb
#threads 0,32 # production
workers 2
threads 0,16
workers 0
port 3000

#daemonize # production

$app_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
tmp_dir  = "#{$app_path}/tmp"
log_dir  = "#{$app_path}/log"
tmp_puma = "#{tmp_dir}/puma"
dirs = []
dirs << log_dir  unless (File.directory? log_dir)
dirs << tmp_dir  unless (File.directory? tmp_dir)
dirs << tmp_puma unless (File.directory? tmp_puma)

begin
  require 'fileutils'
  FileUtils::mkdir(dirs) if dirs.length > 0
rescue
  $stderr.puts 'Unable to create directories'
end


stdout_redirect 'log/stdout.log', 'log/stdout.log', true
pidfile 'tmp/puma/puma.pid'
state_path 'tmp/puma/puma.state'

prune_bundler
preload_app!


