require_relative '../../../../utils/analyzers/cfd_analyzer'

describe CfdAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(CfdAnalyzer.analyze(nil, nil)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(CfdAnalyzer.analyze("", nil)).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(CfdAnalyzer.analyze("[]", nil)).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(CfdAnalyzer.analyze("{}", nil)).to be_empty
    end

    it 'returns cfd data' do
      now = DateTime.now

      latest = now.strftime("%FT%T%:z")
      middle = (now - 3.days).strftime("%FT%T%:z")
      earliest = (now - 5.days).strftime("%FT%T%:z")

      raw = '{"id":"53adf649de82087387769b23","name":"Test Board #1",' +
             '"lists":[{"id":"53adf649de82087387769b24","name":"To Do","closed":false},{"id":"53adf649de82087387769b25","name":"Doing","closed":false},{"id":"53adf649de82087387769b26","name":"Done","closed":false}],' +
             '"actions":[{"id":"53c513ecad88abb695d17ea5","data":{"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"list":{"name":"To Do","id":"53adf649de82087387769b24"},"card":{"shortLink":"aAa9QfBc","idShort":6,"name":"Test card 6","id":"53c513ecad88abb695d17ea4"}},"type":"createCard","date":"' + latest + '"},' +
             '{"id":"53c51190bafc444b8dd834d6","data":{"listAfter":{"name":"Doing","id":"53adf649de82087387769b25"},"listBefore":{"name":"To Do","id":"53adf649de82087387769b24"},"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"card":{"shortLink":"okTPlfQ2","idShort":2,"name":"Test card 2","id":"53adf6530c52105b50069487","idList":"53adf649de82087387769b25"},"old":{"idList":"53adf649de82087387769b24"}},"type":"updateCard","date":"' + middle + '"},' +
             '{"id":"53adf65e7e083105f327da76","data":{"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"list":{"name":"Done","id":"53adf649de82087387769b26"},"card":{"shortLink":"fbWh55LG","idShort":5,"name":"Test card 5","id":"53adf65e7e083105f327da75"}},"type":"createCard","date":"' + middle + '"},' +
             '{"id":"53adf65b069f1408e5b18d6d","data":{"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"list":{"name":"Done","id":"53adf649de82087387769b26"},"card":{"shortLink":"hxhrCojg","idShort":4,"name":"Test card 4","id":"53adf65b069f1408e5b18d6c"}},"type":"createCard","date":"' + middle + '"},' +
             '{"id":"53adf657976419d68e75e4d4","data":{"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"list":{"name":"Doing","id":"53adf649de82087387769b25"},"card":{"shortLink":"t1zlFGq6","idShort":3,"name":"Test card 3","id":"53adf657976419d68e75e4d3"}},"type":"createCard","date":"' + earliest + '"},' +
             '{"id":"53adf6530c52105b50069488","data":{"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"list":{"name":"To Do","id":"53adf649de82087387769b24"},"card":{"shortLink":"okTPlfQ2","idShort":2,"name":"Test card 2","id":"53adf6530c52105b50069487"}},"type":"createCard","date":"' + earliest + '"},' +
             '{"id":"53adf6510ad5d8524d8dc356","data":{"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"list":{"name":"To Do","id":"53adf649de82087387769b24"},"card":{"shortLink":"90yw2Uln","idShort":1,"name":"Test card 1","id":"53adf6510ad5d8524d8dc355"}},"type":"createCard","date":"' + earliest + '"}]}'

      expect(CfdAnalyzer.analyze(raw, nil)).to match({
        dates: (now - 5.days).upto(now).map {|date| date.strftime("%b %-d")},
        cfddata: [
          {name: "To Do", data: [2, 2, 1, 1, 1, 2]},
          {name: "Doing", data: [1, 1, 2, 2, 2, 2]},
          {name: "Done", data: [0, 0, 2, 2, 2, 2]}
        ]
      })
    end

    it 'handles more than 1000 actions' do   
      now = DateTime.now

      latest = now.strftime("%FT%T%:z")
      middle = (now - 3.days).strftime("%FT%T%:z")
      earliest = (now - 5.days).strftime("%FT%T%:z")

      raw = '{"id":"53adf649de82087387769b23","name":"Test Board #1",' +
             '"lists":[{"id":"53adf649de82087387769b24","name":"To Do","closed":false},{"id":"53adf649de82087387769b25","name":"Doing","closed":false},{"id":"53adf649de82087387769b26","name":"Done","closed":false}],' +
             '"actions":['

      raw += 999.times.collect {'{"id":"53c51190bafc444b8dd834d6","data":{"listAfter":{"name":"Doing","id":"53adf649de82087387769b25"},"listBefore":{"name":"To Do","id":"53adf649de82087387769b24"},"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"card":{"shortLink":"okTPlfQ2","idShort":2,"name":"Test card 2","id":"53adf6530c52105b50069487","idList":"53adf649de82087387769b25"},"old":{"idList":"53adf649de82087387769b24"}},"type":"updateCard","date":"' + middle + '"},'}.join

      raw += '{"id":"53adf6510ad5d8524d8dc356","data":{"board":{"shortLink":"Ntr24nv0","name":"Test Board #1","id":"53adf649de82087387769b23"},"list":{"name":"To Do","id":"53adf649de82087387769b24"},"card":{"shortLink":"90yw2Uln","idShort":1,"name":"Test card 1","id":"53adf6510ad5d8524d8dc355"}},"type":"createCard","date":"' + earliest + '"}]}'

      action_fetcher = double(Proc)
      expect(action_fetcher).to receive(:call).once.with(earliest, {}).and_return("[]")

      expect(CfdAnalyzer.analyze(raw, action_fetcher)).to match({
        dates: (now - 5.days).upto(now).map {|date| date.strftime("%b %-d")},
        cfddata: [
          {name: "To Do", data: [1, 1, 1, 1, 1, 1]},
          {name: "Doing", data: [0, 0, 1, 1, 1, 1]},
          {name: "Done", data: [0, 0, 0, 0, 0, 0]}
        ]
      })
    end
  end
end
