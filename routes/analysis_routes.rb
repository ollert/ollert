require 'json'
require 'require_all'

require_rel '../utils'

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
      body ProgressChartsAnalyzer.analyze(ProgressChartsFetcher.fetch(client, board_id),
       params["startingList"], params["endingList"]).to_json
      status 200
    rescue Trello::Error => e
      body "Connection broken."
      status 500
    end
  end

  get '/api/v1/listchanges/:board_id' do |board_id|
    client = Trello::Client.new developer_public_key: ENV['PUBLIC_KEY'], member_token: params['token']

    begin
      lists = client.get("/boards/#{board_id}/lists", filter: 'open').json_into(Trello::List)
      all = Util::ListAction.actions(client, board_id)

      {
        lists: lists.map {|l| {id: l.id, name: l.name}},
        times: Util::Analyzers::TimeTracker.by_card(all)
      }.to_json
    rescue Exception => e
      body 'Connection broken.'
      status 500
    end
  end

  # TODO: Finish
  get '/api/v1/cycletime/:board_id' do |board_id|
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params["token"]
    )

    begin
      body CycleTimeAnalyzer.analyze(CycleTimeFetcher.fetch(client, board_id),
        params["startingList"], params["endingList"]).to_json
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
      body StatsAnalyzer.analyze(StatsFetcher.fetch(client, board_id)).to_json
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
