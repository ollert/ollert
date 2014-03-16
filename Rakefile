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

require 'sequel'
require 'dotenv/tasks'

task :load_db, :dotenv do
  DB = Sequel.connect ENV['DATABASE_URL']
end

namespace :db do
  Sequel.extension :migration
  
  desc "Prints current schema version"
  task :version => :load_db do
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0
 
    puts "Schema Version: #{version}"
  end
 
  desc "Perform migration up to latest migration available"
  task :migrate => :load_db do
    Sequel::Migrator.run(DB, "db/migrations")
    Rake::Task['db:version'].execute
  end
    
  desc "Perform migration to specified target or full rollback as default"
  task :rollback, [:target] => :load_db do |t, args|
    args.with_defaults(:target => 0)
 
    Sequel::Migrator.run(DB, "db/migrations", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end
 
  desc "Perform migration reset (full rollback and migration)"
  task :reset => [:rollback, :migrate, :load_app] do
  end

  desc "Dump schema"
  task :schema_dump => :dotenv do
    puts `sequel -D #{ENV['DATABASE_URL']}`
  end
end
