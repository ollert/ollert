require 'haml'
require 'mongoid'
require 'rack-flash'
require 'rack/ssl'
require 'rack/rewrite'
require 'sinatra/base'
require 'sinatra/respond_with'

class Ollert < Sinatra::Base
  register Sinatra::RespondWith
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  configure do
    use Rack::MethodOverride
    use Rack::Deflater

    I18n.enforce_available_locales = true
    Mongoid.load! "#{File.dirname(__FILE__)}/mongoid.yml"
  end

  puts "SESSION_SECRET=#{ENV["SESSION_SECRET"]}"
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
          flash[:warning] = "Hey! You should create an account to do that."
          redirect '/'
        end
      end
    end
  end
end

Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each do |file|
  require file.chomp(File.extname(file))
end

Dir.glob("#{File.dirname(__FILE__)}/routes/*.rb").each do |file|
  require file.chomp(File.extname(file))
end
