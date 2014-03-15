require 'sinatra'
require 'haml'

DEV_SECRET = "0942956f9eeea22688d8717ec9e12955"
APP_NAME = "ollert"

class Ollert < Sinatra::Base
  get '/' do
    haml :landing
  end

  get '/connect' do
    ret_url = request.url + "/trello"
    redirect "https://trello.com/1/authorize?callback_method=fragment&return_url=#{ret_url}&key=#{DEV_SECRET}&name=#{APP_NAME}&expiration=never&response_type=token"
  end

  get '/connect/trello' do
    puts params[:id]
  end
end
