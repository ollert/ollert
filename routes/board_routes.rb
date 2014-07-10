require 'trello'

require_relative '../utils/fetchers/board_fetcher'
require_relative '../utils/analyzers/board_analyzer'

class Ollert
  get '/boards', :auth => :none do
    if !@user.nil? && !@user.member_token.nil?
      session[:token] = @user.member_token
    elsif !params[:token].nil? && !params[:token].empty?
      session[:token] = params[:token]
    else
      flash[:info] = "Log in or connect with Trello to analyze your boards."
      redirect '/'
    end

    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )
    token = client.find(:token, session[:token])

    member = token.member

    # this logic needs to be fixed - why does this belong here?
    unless @user.nil?
      @user.member_token = session[:token]
      @user.trello_name = member.attributes[:username]
      @user.save
    end
    
    # change this to be async
    @boards = BoardAnalyzer.analyze(BoardFetcher.fetch(client, client.find(:token, session[:token])))

    haml_view_model :boards, @user
  end

  get '/boards/:id', :auth => :token do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    @boards = BoardAnalyzer.analyze(BoardFetcher.fetch(client, client.find(:token, session[:token])))

    @board_name = @boards.values.flatten.select {|x| x["id"] == board_id}.first["name"]
    @board_id = board_id

    haml_view_model :analysis, @user
  end
end
