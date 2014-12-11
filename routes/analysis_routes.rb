require 'json'

Dir.glob("#{File.dirname(__FILE__)}/../utils/fetchers/*.rb").each do |file|
  require file.chomp(File.extname(file))
end

Dir.glob("#{File.dirname(__FILE__)}/../utils/analyzers/*.rb").each do |file|
  require file.chomp(File.extname(file))
end

class Ollert
  ["/api/v1/*"].each do |path|
    before path do
      if params["token"].nil?
        halt 400, "Missing token."
      end
    end
  end

  get '/api/v1/progress/:board_id' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params["token"]
    )

    begin
      data = ProgressChartsFetcher.fetch(client, board_id)

      action_fetcher = Proc.new { |date| ProgressChartsFetcher.fetch_actions(client, board_id, date) }
      body ProgressChartsAnalyzer.analyze(data, action_fetcher,
        params["starting_list"], params["ending_list"]).to_json
      status 200
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end

  get '/api/v1/cycletime/:board_id' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params["token"]
    )

    begin
      body CycleTimeAnalyzer.analyze(CycleTimeFetcher.fetch(client, board_id),
        params["starting_list"], params["ending_list"]).to_json
      status 200
    rescue
      body "Connection broken."
      status 500
    end
  end

  get '/api/v1/wip/:board_id' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params["token"]
    )

    begin
      body WipAnalyzer.analyze(WipFetcher.fetch(client, board_id)).to_json
      status 200
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end

  get '/api/v1/stats/:board_id' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params['token']
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
  
  get '/api/v1/labels/:board_id' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params['token']
    )

    begin
      body LabelCountAnalyzer.analyze(LabelCountFetcher.fetch(client, board_id)).to_json
      status 200
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end
end
