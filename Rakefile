require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

task :default => [:start]

desc 'Starts the application on specified port (default 4000)'
task :start, [:port] do |t, args|
  args.with_defaults(:port => 4000)
  exec "rackup -p #{args[:port]}"
end
