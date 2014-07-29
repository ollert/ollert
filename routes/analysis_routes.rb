require 'json'

require_relative '../utils/fetchers/label_count_fetcher'
require_relative '../utils/analyzers/label_count_analyzer'
require_relative '../utils/fetchers/wip_fetcher'
require_relative '../utils/analyzers/wip_analyzer'
require_relative '../utils/fetchers/cfd_fetcher'
require_relative '../utils/analyzers/cfd_analyzer'
require_relative '../utils/fetchers/stats_fetcher'
require_relative '../utils/analyzers/stats_analyzer'

class Ollert
  get '/boards/:board_id/analysis/wip' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    begin
      status 200
      body WipAnalyzer.analyze(WipFetcher.fetch(client, board_id)).to_json
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end

  get '/boards/:id/analysis/cfd' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    action_fetcher = Proc.new { |date| CfdFetcher.fetch_actions(client, board_id, date) }

    begin
      status 200
      body CfdAnalyzer.analyze(CfdFetcher.fetch(client, board_id), action_fetcher).to_json
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end
  
  get '/boards/:id/analysis/stats' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    action_fetcher = Proc.new { |date| StatsFetcher.fetch_actions(client, board_id, date) }

    begin
      status 200
      body StatsAnalyzer.analyze(StatsFetcher.fetch(client, board_id), action_fetcher).to_json
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end
  
  get '/boards/:id/analysis/labelcounts' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
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
