require 'trello'

require_relative '../utils/fetchers/board_fetcher'
require_relative '../utils/analyzers/board_analyzer'
require_relative '../utils/fetchers/member_fetcher'
require_relative '../utils/analyzers/member_analyzer'
require_relative '../utils/analyzers/board_details_analyzer'
require_relative '../utils/fetchers/board_details_fetcher'

class Ollert
  get '/boards', :auth => :connected do
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => @user.member_token
    )

    begin
      @boards = BoardAnalyzer.analyze(BoardFetcher.fetch(client, @user.trello_name))
    rescue Trello::Error => e
      unless @user.nil?
        @user.member_token = nil
        @user.trello_name = nil
        @user.save
      end

      respond_to do |format|
        format.html do
          flash[:error] = "There's something wrong with the Trello connection. Please re-establish the connection."
          redirect '/'
        end

        format.json { status 400 }
      end
    end

    respond_to do |format|
      format.html { haml :boards }
      format.json { {'data' => @boards }.to_json }
    end
  end

  get '/boards/:id', :auth => :connected do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => @user.member_token
    )

    begin
      details = BoardDetailsAnalyzer.analyze(BoardDetailsFetcher.fetch(client, board_id))
      @board_name = details[:name]
      @board_states = details[:lists]

      boardSettings = @user.boards.find_or_create_by(board_id: board_id)

      boardSettings.starting_list = savedListOrDefault(boardSettings.starting_list, @board_states, @board_states.first)
      boardSettings.ending_list = savedListOrDefault(boardSettings.ending_list, @board_states, @board_states.last)

      boardSettings.save

      @starting_list = boardSettings.starting_list
      @ending_list = boardSettings.ending_list
    rescue Trello::Error => e
      unless @user.nil?
        @user.member_token = nil
        @user.trello_name = nil
        @user.save
      end

      respond_to do |format|
        format.html do
          flash[:error] = "There's something wrong with the Trello connection. Please re-establish the connection."
          redirect '/'
        end

        format.json { status 400 }
      end
    end

    @board_id = board_id

    haml :analysis
  end

  def savedListOrDefault(savedListName, listOptions, defaultListName)
    !savedListName.nil? && listOptions.any? {|l| l == savedListName} ? savedListName : defaultListName
  end
end