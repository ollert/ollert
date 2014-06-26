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

desc "Start application based on environment"
task :start do
  exec("foreman start -p 4000")
end

require 'mongoid'

task :console do
  Mongoid.load! "#{File.dirname(__FILE__)}/mongoid.yml", ENV['RACK_ENV'] || "development"

  Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each do |file|
    require file.chomp(File.extname(file))
  end

  require 'irb'
  ARGV.clear
  IRB.start
end
