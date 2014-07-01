require 'haml'
require 'mongoid'
require 'rack-flash'
require 'rack/ssl'
require 'sinatra/base'

require_relative 'helpers/ollert_helpers'

class Ollert < Sinatra::Base
  include OllertHelpers

  configure do
    if ENV['RACK_ENV'] == 'development'
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end

    Mongoid.load! "#{File.dirname(__FILE__)}/mongoid.yml"
  end

  use Rack::Session::Cookie, secret: ENV['SESSION_SECRET'], expire_after: 30 * (60*60*24) # 30 days in seconds
  use Rack::Flash, sweep: true
  use Rack::SSL, :exclude => ->(_){ ENV['RACK_ENV'] != "production" }

  set(:auth) do |role|
    condition do
      @user = get_user
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
