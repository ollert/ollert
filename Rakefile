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
      r.rspec_opts = '--color --format documentation --tag ~integration:true'
    end

    RSpec::Core::RakeTask.new(:integration) do |r|
      r.pattern = "test/**/*_spec.rb"
      r.rspec_opts = '--color --format documentation --tag integration:true'
    end

    desc 'Setup Integration'
    task :setup do
      require 'dotenv'
      require 'launchy'
      Dotenv.load
      raise 'PUBLIC_KEY is not part of your .env' unless ENV['PUBLIC_KEY']

      File.open('.env', 'a') do |f|
        f.puts "INTEGRATION_KEY=#{ENV['PUBLIC_KEY']}"
        f.puts 'INTEGRATION_TOKEN=<value copied after accepting>'
      end
      Launchy.open "https://trello.com/1/authorize?key=#{ENV['PUBLIC_KEY']}&scope=read%2Cwrite&name=Ollert+Integration+Tests&expiration=never&response_type=token"
      puts "Copy the value shown to you after you choose to 'Allow' the Ollert Integration Tests application"
    end

    desc 'Run all JavaScript specs'
    task :js do
      system('testem ci') or fail
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
    task :all => [:spec, :integration, :js, :cukes] do
    end
  end
end

