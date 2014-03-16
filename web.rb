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

    require_relative 'models/user'
    require_relative 'models/board'
  end

  set(:auth) do |role|
    condition do
      @user = get_user
      if role == :authenticated
        if @user.nil?
          session[:user] = nil
          flash[:warning] = "Hey! You should log in to do that action."
          redirect '/'
        end
      end
    end
  end

  get '/', :auth => :none do
    unless @user.nil? || @user.member_token.nil?
      redirect '/boards'
    end
    
    haml_view_model :landing, @user
  end

  get '/boards', :auth => :none do
    session[:token] = params[:token]
    client = get_client ENV['PUBLIC_KEY'], params[:token]

    token = client.find(:token, session[:token])
    member = token.member
    session[:member_name] = member.id

    @boards = member.boards.group_by {|board| board.organization_id.nil? ? "Unassociated Boards" : board.organization.name}

    haml_view_model :boards, @user
  end

  get '/boards/:id', :auth => :none do |board_id|
    client = get_client ENV['PUBLIC_KEY'], session[:token]
    @board = client.find :board, board_id

    @wip_data = Hash.new
    options = {limit: 999}
    cards = @board.cards options
    lists = @board.lists options
    actions = @board.actions options

    cards.group_by { |x| x.list.name }.each_pair do |k,v|
      @wip_data[k] = v.count
    end

    @cfd_data = get_cfd_data(actions, cards, lists.collect(&:name))

    @stats = get_stats(@board)

    haml_view_model :analysis, @user
  end

  get '/signup' do
    haml_view_model :signup, @user
  end

  post '/signup' do
    msg = validate_signup(params)
    if msg.empty?
      user = User.new
      user.email = params[:email]
      user.password = params[:password]
      user.membership_type = get_membership_type params

      if user.save
        session[:user] = user.id
        flash[:success] = "You're signed up! Click below to connect with Trello for the first time."
        redirect '/'
      else
        flash[:error] = "Something's broken, please try again later."
        @email = params[:email]
        @membership = get_membership_type params
        haml_view_model :signup
      end
    else
      flash[:error] = msg
      @email = params[:email]
      @membership = get_membership_type params
      haml_view_model :signup
    end
  end

  get '/login' do
    haml_view_model :login
  end

  post '/authenticate' do
    user = User.find email: params['email']
    if user.nil?
      flash[:warning] = "Email address #{params['email_address']} does not appear to be registered."
      redirect :login
    elsif !user.authenticate? params['password']
      flash[:warning] = "I didn't find that username/password combination. Check your spelling."
      redirect :login
    else
      flash[:success] = "Welcome back."
      session[:user] = user.id
      redirect '/'
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
