require 'sinatra'
require 'haml'
require 'sass'
require 'trello'
require 'active_support/inflector'

PUBLIC_KEY = "0942956f9eeea22688d8717ec9e12955"
APP_NAME = "ollert"

class Ollert < Sinatra::Base
  enable :sessions

  get '/' do
    @secret = PUBLIC_KEY
    haml :landing
  end

  get '/boards' do
    session[:token] = params[:token]
    client = Trello::Client.new(
      :developer_public_key => PUBLIC_KEY,
      :member_token => session[:token]
    )

    token = client.find(:token, session[:token])
    member = token.member
    session[:member_name] = member.id

    @boards = member.boards.group_by {|board| board.organization_id.nil? ? "Unassociated Boards" : board.organization.name}

    haml :boards
  end

  get '/boards/:id' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => PUBLIC_KEY,
      :member_token => session[:token]
    )

    @board = client.find :board, board_id

    haml :dashboard
  end

  get '/fail' do
    "auth failed"
  end

  get '/styles.css' do
    scss :styles
  end
end
