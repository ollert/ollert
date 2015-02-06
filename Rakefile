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

desc "Open irb with an open connection to the database"
task :console do
  Mongoid.load! "#{File.dirname(__FILE__)}/mongoid.yml", ENV['RACK_ENV'] || "development"

  Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each do |file|
    require file.chomp(File.extname(file))
  end

  require 'irb'
  ARGV.clear
  IRB.start
end

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'

  namespace :test do
    RSpec::Core::RakeTask.new(:spec) do |r|
      r.pattern = "test/**/*_spec.rb"
      r.rspec_opts = []
      r.rspec_opts << '--color'
      r.rspec_opts << '--format documentation'
    end

    desc "Run all Cucumber tests"
    task :cukes do
      ruby "-S cucumber #{File.dirname(__FILE__)}/test/features"
    end

    desc "Run a single Cuke test"
    task :cuke, [:feature] do |t, args|
      ruby "-S cucumber -v -r #{File.dirname(__FILE__)}/test/features #{File.dirname(__FILE__)}/test/features/#{args[:feature]}.feature"
    end

    desc "Run spec tests and cukes"
    task :all => [:spec, :cukes] do
    end
  end
end
