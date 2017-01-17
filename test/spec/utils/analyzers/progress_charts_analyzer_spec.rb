require_relative '../../../../utils/analyzers/progress_charts_analyzer'

describe ProgressChartsAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(ProgressChartsAnalyzer.analyze(nil, "", "", false)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(ProgressChartsAnalyzer.analyze("", "", "", false)).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(ProgressChartsAnalyzer.analyze([], "", "", false)).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(ProgressChartsAnalyzer.analyze({}, "", "", false)).to be_empty
    end

    it 'returns default cfd data' do
      now = DateTime.now.utc.to_date

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

      expect(ProgressChartsAnalyzer.analyze(JSON.parse(raw), "", "", false)).to match({
        cfd: {
          cfddata: [
            {name: "To Do", data: [d(5, 2), d(4, 2), d(3, 1), d(2, 1), d(1, 1), d(0, 2)]},
            {name: "Doing", data: [d(5, 1), d(4, 1), d(3, 2), d(2, 2), d(1, 2), d(0, 2)]},
            {name: "Done", data: [d(5, 0), d(4, 0), d(3, 2), d(2, 2), d(1, 2), d(0, 2)]}
          ]
        },
        burnup: {
          cfddata: [
            {name: "InScope", data: [d(5, 3), d(4, 3), d(3, 3), d(2, 3), d(1, 3), d(0, 4)]},
            {name: "Complete", data: [d(5, 0), d(4, 0), d(3, 2), d(2, 2), d(1, 2), d(0, 2)]}
          ]
        }
      })
    end

    it 'returns cfd data with given starting and ending list' do
      now = DateTime.now.utc.to_date

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

      expect(ProgressChartsAnalyzer.analyze(JSON.parse(raw), "53adf649de82087387769b24", "53adf649de82087387769b25", false)).to match({
        cfd: {
          cfddata: [
            {name: "To Do", data: [d(5, 2), d(4, 2), d(3, 1), d(2, 1), d(1, 1), d(0, 2)]},
            {name: "Doing", data: [d(5, 1), d(4, 1), d(3, 2), d(2, 2), d(1, 2), d(0, 2)]},
          ]
        },
        burnup: {
          cfddata: [
            {name: "InScope", data: [d(5, 2), d(4, 2), d(3, 1), d(2, 1), d(1, 1), d(0, 2)]},
            {name: "Complete", data: [d(5, 1), d(4, 1), d(3, 4), d(2, 4), d(1, 4), d(0, 4)]}
        ]
        }
      })
    end
  end

  # so named to make the above expectations more terse.
  # this method takes two integers: how many days ago,
  # and a data point. it returns an array containing a
  # datestamp (for x days ago) and the data point
  def d(how_many_days_ago, datum)
    now = DateTime.now.utc.to_date
    date = now - how_many_days_ago.days
    [date.strftime('%s000').to_i, datum]
  end
end
