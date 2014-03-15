require 'sinatra'
require 'haml'
require 'sass'

DEV_SECRET = "0942956f9eeea22688d8717ec9e12955"
APP_NAME = "ollert"

class Ollert < Sinatra::Base
  get '/' do
    @secret = DEV_SECRET
    haml :landing
  end
  
  get '/connect' do
    "Holy cow I received the following token: #{params[:token]}"
  end

  get '/styles.css' do
    scss :styles
  
  get '/dashboard' do
    haml :dashboard

  end
end
