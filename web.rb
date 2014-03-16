require 'sinatra'
require 'haml'
require 'sass'
require 'trello'
require 'active_support/inflector'
require 'json'
require 'rack-flash'
require 'sequel'
require 'dotenv'

require_relative 'helpers/ollert_helpers'

class Ollert < Sinatra::Base
  include OllertHelpers
  use Rack::Flash, sweep: true

  enable :sessions

  configure do
    Dotenv.load!
    Sequel.connect ENV['DATABASE_URL']
  end

  get '/' do
    @secret = ENV['PUBLIC_KEY']
    haml :landing
  end

  get '/boards' do
    session[:token] = params[:token]
    client = get_client ENV['PUBLIC_KEY'], params[:token]

    token = client.find(:token, session[:token])
    member = token.member
    session[:member_name] = member.id

    @boards = member.boards.group_by {|board| board.organization_id.nil? ? "Unassociated Boards" : board.organization.name}

    haml_view_model :boards
  end

  get '/boards/:id' do |board_id|
    client = get_client ENV['PUBLIC_KEY'], session[:token]

    @board = client.find :board, board_id

    @wip_data = Hash.new
    @board.cards.group_by { |x| x.list.name }.each_pair do |k,v|
      @wip_data[k] = v.count
    end

    @stats = get_stats(@board)

    haml_view_model :analysis
  end

  get '/signup' do
    haml_view_model :signup
  end

  post '/signup' do
    msg = validate_signup(params)
    if msg.empty?
      flash[:success] = "You're signed up! Unfortunately, this currently means nothing. :)"
      redirect '/'
    else
      flash[:error] = msg
      @email
      haml_view_model :signup
    end
  end

  get '/terms' do
    "TBD"
  end

  get '/privacy' do
    "TBD"
  end

  get '/fail' do
    "auth failed"
  end

  get '/styles.css' do
    scss :styles
  end
end
