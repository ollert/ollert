require_relative '../../../../utils/analyzers/board_analyzer'

describe BoardAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(BoardAnalyzer.analyze(nil)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(BoardAnalyzer.analyze("")).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(BoardAnalyzer.analyze([])).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(BoardAnalyzer.analyze({})).to be_empty
    end

    it 'returns hash of boards' do
      raw = '[{"organization": {"displayName": "The Kremlin"}, "id": "23j9jfd9j", "name": "Oppression"}, ' +
            '{"id": "ujfwj3001", "name": "Groceries"},' +
            '{"id": "sajiw123e", "name": "Workout"},' +
            '{"organization": {"displayName": "The Kremlin"}, "id": "111223333", "name": "Espionage"}]'

      board_lists = BoardAnalyzer.analyze(JSON.parse(raw))

      expect(board_lists).to match({
        "My Boards" => [{"id" => "ujfwj3001", "name" => "Groceries"}, {"id" => "sajiw123e", "name" => "Workout"}],
        "The Kremlin" => [
          {"organization" => {"displayName" => "The Kremlin"}, "id" => "23j9jfd9j", "name" => "Oppression"},
          {"organization" => {"displayName" => "The Kremlin"}, "id" => "111223333", "name" => "Espionage"}
        ]
      })
    end
  end
end
