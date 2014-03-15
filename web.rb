require 'sinatra'
require 'haml'
require 'sass'
require 'trello'
require 'active_support/inflector'
require 'json'

require_relative 'helpers/ollert_helpers'

PUBLIC_KEY = "0942956f9eeea22688d8717ec9e12955"
APP_NAME = "ollert"

class Ollert < Sinatra::Base
  include OllertHelpers

  enable :sessions

  get '/' do
    @secret = PUBLIC_KEY
    haml :landing
  end

  get '/boards' do
    session[:token] = params[:token]
    client = get_client PUBLIC_KEY, params[:token]

    token = client.find(:token, session[:token])
    member = token.member
    session[:member_name] = member.id

    @boards = member.boards.group_by {|board| board.organization_id.nil? ? "Unassociated Boards" : board.organization.name}

    haml_view_model :boards
  end

  get '/boards/:id' do |board_id|
    client = get_client PUBLIC_KEY, session[:token]

    @board = client.find :board, board_id

    @wip_data = Hash.new
    @board.cards.group_by { |x| x.list.name }.each_pair do |k,v|
      @wip_data[k] = v.count
    end

    @members_per_card = get_members_per_card_data(@board.cards)
    @list_with_most_cards = get_list_with_most_cards(@board.lists)
    @list_with_least_cards = get_list_with_least_cards(@board.lists)

    haml_view_model :analysis
  end

  get '/signup' do
    haml_view_model :signup
  end

  post '/signup' do
    "not implemented"
  end

  get '/fail' do
    "auth failed"
  end

  get '/styles.css' do
    scss :styles
  end
end
