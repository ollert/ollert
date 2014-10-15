require 'json'

require_relative '../utils/fetchers/label_count_fetcher'
require_relative '../utils/analyzers/label_count_analyzer'
require_relative '../utils/fetchers/wip_fetcher'
require_relative '../utils/analyzers/wip_analyzer'
require_relative '../utils/fetchers/progress_charts_fetcher'
require_relative '../utils/analyzers/progress_charts_analyzer'
require_relative '../utils/fetchers/stats_fetcher'
require_relative '../utils/analyzers/stats_analyzer'

class Ollert
  get '/boards/:board_id/analysis/wip', :auth => :connected do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => @user.member_token
    )

    begin
      status 200
      body WipAnalyzer.analyze(WipFetcher.fetch(client, board_id)).to_json
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end

  get '/boards/:id/analysis/progress', :auth => :connected do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => @user.member_token
    )

    begin
      data = ProgressChartsFetcher.fetch(client, board_id)

      boardSettings = @user.boards.find_or_create_by(board_id: board_id)
      boardSettings.starting_list = params["startingList"]
      boardSettings.ending_list = params["endingList"]
      boardSettings.save

      action_fetcher = Proc.new { |date| ProgressChartsFetcher.fetch_actions(client, board_id, date) }
      body ProgressChartsAnalyzer.analyze(data, action_fetcher, boardSettings.starting_list, boardSettings.ending_list).to_json
      status 200
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end

  get '/boards/:id/analysis/stats', :auth => :connected do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => @user.member_token
    )

    begin
      action_fetcher = Proc.new { |date| StatsFetcher.fetch_actions(client, board_id, date) }
      body StatsAnalyzer.analyze(StatsFetcher.fetch(client, board_id), action_fetcher).to_json
      status 200
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end
  
  get '/boards/:id/analysis/labelcounts', :auth => :connected do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => @user.member_token
    )

    begin
      status 200
      body LabelCountAnalyzer.analyze(LabelCountFetcher.fetch(client, board_id)).to_json
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end
end
