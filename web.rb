require 'sinatra'
require 'haml'
require 'sass'
require 'trello'
require 'active_support/inflector'

PUBLIC_KEY = "0942956f9eeea22688d8717ec9e12955"
APP_NAME = "ollert"

class Ollert < Sinatra::Base
  get '/' do
    @secret = PUBLIC_KEY
    haml :landing
  end

  get '/connect' do
    client = Trello::Client.new(
      :developer_public_key => PUBLIC_KEY,
      :member_token => params[:token]
    )

    token = client.find(:token, params[:token])
    member = token.member
    "Boards: #{member.boards.count}"

    # Trello.configure do |config|
    #   config.developer_public_key = PUBLIC_KEY
    #   config.member_token = params[:token]
    # end

    # puts Trello::Member.find("_larryprice").boards.count
  end

  get '/styles.css' do
    scss :styles
  end
end
