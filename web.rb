require 'haml'
require 'mongoid'
require 'pony'
require 'rack-flash'
require 'rack/ssl'
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
    
    Pony.options = {
      :via => :smtp,
      :via_options => {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :domain => 'ollertapp.com',
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    }

    I18n.enforce_available_locales = true
    Mongoid.load! "#{File.dirname(__FILE__)}/mongoid.yml"
  end

  use Rack::Session::Cookie, secret: ENV['SESSION_SECRET'], expire_after: 30 * (60*60*24) # 30 days in seconds
  use Rack::Flash, sweep: true
  use Rack::SSL, :exclude => ->(_){ ENV['RACK_ENV'] != "production" }

  set(:auth) do |role|
    condition do
      @user = session[:user].nil? ? nil : User.find(session[:user])
      if role == :authenticated
        if @user.nil?
          session[:user] = nil
          flash[:warning] = "Hey! You should create an account to do that."
          redirect '/'
        end
      elsif role == :token
        if session[:token].nil? || session[:token].empty?
          flash[:info] = "Log in or connect with Trello to analyze your boards."
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
