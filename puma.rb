workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 4000
environment ENV['RACK_ENV'] || 'development'

on_restart do
  Mongoid.disconnect_clients
end
