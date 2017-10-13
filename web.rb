require 'haml'
require 'mongoid'
require 'rack-flash'
require 'rack/ssl'
require 'rack/rewrite'
require 'rack-timeout'
require 'sinatra/base'
require 'sinatra/respond_with'
require 'trello'
require 'trello/json_utils'
require_relative 'helpers'

class Ollert < Sinatra::Base
  helpers OllertApp::Helpers

  register Sinatra::RespondWith
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader

    enable :logging
  end

  configure do
    use Rack::MethodOverride
    use Rack::Deflater
    use Rack::Timeout, service_timeout: 30
    Rack::Timeout::Logger.level  = Logger::ERROR

    I18n.enforce_available_locales = true
    Mongoid.load! "#{File.dirname(__FILE__)}/mongoid.yml"
  end

  use Rack::Session::Cookie, secret: ENV['SESSION_SECRET'], expire_after: 30 * (60*60*24) # 30 days in seconds
  use Rack::Flash, sweep: true

  configure :production do
    use Rack::SSL
    use Rack::Rewrite do
      r301 %r{.*}, 'https://ollertapp.com$&', :if => Proc.new {|rack_env|
        rack_env['SERVER_NAME'] != 'ollertapp.com'
      }
    end
  end

  set(:auth) do |role|
    condition do
      @user = session[:user].nil? ? nil : User.find(session[:user])
      if role == :connected
        if @user.nil?
          session[:user] = nil
          flash[:error] = "Hey! You should create an account to do that."
          redirect '/'
        end
      end
    end
  end

  error Trello::Error do
    body "There's something wrong with the Trello connection. Please re-establish the connection."
    status 500
  end
end

Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each do |file|
  require file.chomp(File.extname(file))
end

Dir.glob("#{File.dirname(__FILE__)}/routes/*.rb").each do |file|
  require file.chomp(File.extname(file))
end
