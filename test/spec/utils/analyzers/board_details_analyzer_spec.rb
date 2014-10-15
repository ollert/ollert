require_relative '../../../../utils/analyzers/board_details_analyzer'

describe BoardDetailsAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(BoardDetailsAnalyzer.analyze(nil)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(BoardDetailsAnalyzer.analyze("")).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(BoardDetailsAnalyzer.analyze("[]")).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(BoardDetailsAnalyzer.analyze("{}")).to be_empty
    end

    it 'returns board details' do
      raw = '{"id":"5352919ed45d47fd76cc3f1a","name":"My Board","lists":[' +
        '{"name":"To Do"},' +
        '{"name":"Doing"},' +
        '{"name":"Done"}' +
        ']}'

      expect(BoardDetailsAnalyzer.analyze(raw)).to match({
        :name => "My Board",
        :lists => ["To Do", "Doing", "Done"],
      })
    end
  end
end