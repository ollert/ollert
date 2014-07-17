require_relative '../../../../utils/analyzers/stats_analyzer'

describe StatsAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(StatsAnalyzer.analyze(nil, nil)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(StatsAnalyzer.analyze("", nil)).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(StatsAnalyzer.analyze("[]", nil)).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(StatsAnalyzer.analyze("{}", nil)).to be_empty
    end

    it 'returns stats data' do
      date = DateTime.now

      todays_date = date.strftime("%FT%T%:z")
      oldest_date = (date - 2.days).strftime("%FT%T%:z")

      raw = '{"id":"53ae067d6e969356f310f068","name":"Test Board #2",' +
             '"actions":[{"id":"53c52bbee804e574886fe8f5","date":"' + todays_date + '","data":{"board":{"shortLink":"PIUydJV8","name":"Test Board #2","id":"53ae067d6e969356f310f068"},"list":{"name":"To Do","id":"53ae067d6e969356f310f069"},"card":{"shortLink":"FYNaNDXk","idShort":3,"name":"Test card 3","id":"53c52bbee804e574886fe8f4"}}},' +
             '{"id":"53c52b95d7cdfee1fe1fee04","date":"' + todays_date + '","data":{"board":{"shortLink":"PIUydJV8","name":"Test Board #2","id":"53ae067d6e969356f310f068"},"list":{"name":"Done","id":"53ae067d6e969356f310f06b"},"card":{"shortLink":"cQrqwycL","idShort":2,"name":"Test card 2","id":"53c52b95d7cdfee1fe1fee03"}}},' +
             '{"id":"53c52b91d629cabd499f6113","date":"' + oldest_date + '","data":{"board":{"shortLink":"PIUydJV8","name":"Test Board #2","id":"53ae067d6e969356f310f068"},"list":{"name":"To Do","id":"53ae067d6e969356f310f069"},"card":{"shortLink":"wdWMpPma","idShort":1,"name":"Test card 1","id":"53c52b91d629cabd499f6112"}}}],' +
             '"lists":[{"id":"53ae067d6e969356f310f069","name":"To Do","closed":false},{"id":"53ae067d6e969356f310f06a","name":"Doing","closed":false},{"id":"53ae067d6e969356f310f06b","name":"Done","closed":false}],' +
             '"cards":[{"id":"53c52b91d629cabd499f6112","idList":"53ae067d6e969356f310f069","name":"Test card 1","idMembers":["53ada6bd015d8f722abeeab3"]},' +
             '{"id":"53c52bbee804e574886fe8f4","idList":"53ae067d6e969356f310f069","name":"Test card 3","idMembers":[]},' +
             '{"id":"53c52b95d7cdfee1fe1fee03","idList":"53ae067d6e969356f310f06b","name":"Test card 2","idMembers":["53ada6bd015d8f722abeeab3"]}],"members":[{"id":"53ada6bd015d8f722abeeab3","fullName":"Ollert Test User"}]}'

      expect(StatsAnalyzer.analyze(raw, nil)).to match({
        board_members_count: 1,
        card_count: 3,
        avg_members_per_card: 0.67,
        avg_cards_per_member: 2,
        list_with_most_cards_name: "To Do",
        list_with_most_cards_count: 2,
        list_with_least_cards_name: "Doing",
        list_with_least_cards_count: 0,
        oldest_card_name: "Test card 1",
        oldest_card_age: 2,
        newest_card_name: "Test card 3",
        newest_card_age: 0
      })
    end

    it 'handles more than 1000 actions' do   
      date = DateTime.now

      todays_date = date.strftime("%FT%T%:z")
      oldest_date = (date - 2.days).strftime("%FT%T%:z")

      raw = '{"id":"53ae067d6e969356f310f068","name":"Test Board #2",' +
             '"actions":['

      (0..998).each do |i|
          raw += '{"id":"53c52bbee804e574886fe8f5","date":"' + todays_date + '","data":{"board":{"shortLink":"PIUydJV8","name":"Test Board #2","id":"53ae067d6e969356f310f068"},"list":{"name":"To Do","id":"53ae067d6e969356f310f069"},"card":{"shortLink":"FYNaNDXk","idShort":3,"name":"Test card 3","id":"53c52bbee804e574886fe8f4"}}},'
      end
      raw += '{"id":"53c52bbee804e574886fe8f5","date":"' + oldest_date + '","data":{"board":{"shortLink":"PIUydJV8","name":"Test Board #2","id":"53ae067d6e969356f310f068"},"list":{"name":"To Do","id":"53ae067d6e969356f310f069"},"card":{"shortLink":"FYNaNDXk","idShort":3,"name":"Test card 3","id":"53c52bbee804e574886fe8f4"}}}],' + 
             '"lists":[{"id":"53ae067d6e969356f310f069","name":"To Do","closed":false},{"id":"53ae067d6e969356f310f06a","name":"Doing","closed":false},{"id":"53ae067d6e969356f310f06b","name":"Done","closed":false}],' +
             '"cards":[{"id":"53c52b91d629cabd499f6112","idList":"53ae067d6e969356f310f069","name":"Test card 1","idMembers":["53ada6bd015d8f722abeeab3"]},' +
             '{"id":"53c52bbee804e574886fe8f4","idList":"53ae067d6e969356f310f069","name":"Test card 3","idMembers":[]},' +
             '{"id":"53c52b95d7cdfee1fe1fee03","idList":"53ae067d6e969356f310f06b","name":"Test card 2","idMembers":["53ada6bd015d8f722abeeab3"]}],"members":[{"id":"53ada6bd015d8f722abeeab3","fullName":"Ollert Test User"}]}'

      action_fetcher = double(Proc)
      expect(action_fetcher).to receive(:call).once.with(oldest_date).and_return("[]")

      expect(StatsAnalyzer.analyze(raw, action_fetcher)).to match({
            board_members_count: 1,
            card_count: 3,
            avg_members_per_card: 0.67,
            avg_cards_per_member: 2.0,
            list_with_most_cards_name: "To Do",
            list_with_most_cards_count: 2,
            list_with_least_cards_name: "Doing",
            list_with_least_cards_count: 0,
            oldest_card_name: "Test card 3",
            oldest_card_age: 2,
            newest_card_name: "Test card 3",
            newest_card_age: 0
      })
    end
  end
end