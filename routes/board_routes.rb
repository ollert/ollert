require 'trello'

require_relative '../utils/fetchers/board_fetcher'
require_relative '../utils/analyzers/board_analyzer'

class Ollert
  get '/boards', :auth => :none do
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    begin
      @boards = BoardAnalyzer.analyze(BoardFetcher.fetch(client, session[:trello_name]))
    rescue Trello::Error => e
      flash[:error] = "There's something wrong with the Trello connection. Please re-establish the connection."
      if !@user.nil?
        @user.member_token = nil
        @user.trello_name = nil
        @user.save
      end

      redirect '/'
    end

    haml :boards
  end

  get '/boards/:id', :auth => :token do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    begin
      @boards = BoardAnalyzer.analyze(BoardFetcher.fetch(client, session[:trello_name]))
    rescue Trello::Error => e
      flash[:error] = "There's something wrong with the Trello connection. Please re-establish the connection."
      if !@user.nil?
        @user.member_token = nil
        @user.trello_name = nil
        @user.save
      end

      session[:trello_name] = nil
      session[:token] = nil

      redirect '/'
    end

    @board_name = @boards.values.flatten.select {|x| x["id"] == board_id}.first["name"]
    @board_id = board_id

    haml :analysis
  end
end
