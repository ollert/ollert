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

    WipAnalyzer.analyze(WipFetcher.fetch(client, board_id)).to_json
  end

  get '/boards/:id/analysis/cfd' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    CfdAnalyzer.analyze(CfdFetcher.fetch(client, board_id)).to_json
  end
  
  get '/boards/:id/analysis/stats' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    now = Time.now
    data = StatsAnalyzer.analyze(StatsFetcher.fetch(client, board_id)).to_json
    puts Time.now - now

    data
  end
  
  get '/boards/:id/analysis/labelcounts' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => session[:token]
    )

    LabelCountAnalyzer.analyze(LabelCountFetcher.fetch(client, board_id)).to_json
  end
end
