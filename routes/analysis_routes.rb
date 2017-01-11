require 'json'
require 'require_all'

require_rel '../utils'

class Ollert
  ["/api/v1/*"].each do |path|
    before path do
      if env["HTTP_AUTHORIZATION"].nil?
        halt 400, "Missing token."
      end

      @client = Trello::Client.new(developer_public_key: ENV['PUBLIC_KEY'],
                                   member_token: env["HTTP_AUTHORIZATION"])
    end
  end

  get '/api/v1/progress/:board_id' do |board_id|
    body ProgressChartsAnalyzer.analyze(ProgressChartsFetcher.fetch(@client, board_id),
     params["startingList"], params["endingList"]).to_json
    status 200
  end

  get '/api/v1/listchanges/:board_id' do |board_id|
    lists = Trello::List.from_response @client.get("/boards/#{board_id}/lists", filter: 'open')
    cards = Trello::Card.from_response @client.get("/boards/#{board_id}/cards", fields: 'name,closed,idList,idBoard,shortUrl')
    actions = Utils::Fetchers::ListActionFetcher.fetch(@client, board_id)

    {
      lists: lists.map {|l| l.attributes.slice(:id, :name) },
      times: Utils::Analyzers::TimeTracker.by_card(cards: cards, actions: actions)
    }.to_json
  end

  get '/api/v1/wip/:board_id' do |board_id|
    body WipAnalyzer.analyze(WipFetcher.fetch(@client, board_id)).to_json
    status 200
  end

  get '/api/v1/stats/:board_id' do |board_id|
    puts params['show_archived']
    body StatsAnalyzer.analyze(StatsFetcher.fetch(@client, board_id), params['show_archived']).to_json
    status 200
  end

  get '/api/v1/labels/:board_id' do |board_id|
    body LabelCountAnalyzer.analyze(LabelCountFetcher.fetch(@client, board_id)).to_json
    status 200
  end
end
