require_relative '../../../../utils/analyzers/label_count_analyzer'

describe LabelCountAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(LabelCountAnalyzer.analyze(nil)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(LabelCountAnalyzer.analyze("")).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(LabelCountAnalyzer.analyze([])).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(LabelCountAnalyzer.analyze({})).to be_empty
    end

    it 'returns all defined colors' do
      cards = [{"labels" => [{"id" => "1", "color" => "green"}, {"id" => "3", "color" => "yellow"}]},
               {"labels" => [{"id" => "3", "color" => "yellow"}]},
               {"labels" => [{"id" => "2", "name" => "Doing", "color" => "blue"}]},
               {"labels" => [{"id" => "4", "color" => "orange"},{"id" => "5", "color" => "purple"}]},
               {"labels" => [{"id" => "6", "color" => "red"}, {"id" => "7", "color" => "sky"}]},
               {"labels" => [{"id" => "9", "name" => "Completed", "color" => "black"}, {"id" => "8", "color" => "lime"}]},
               {"labels" => [{"id" => "10", "color" => "pink"}]},
               {"labels" => [{"id" => "11", "color" => "mauve"}]}]

      expect(LabelCountAnalyzer.analyze(cards)).to match({
        :labels=>["yellow", "green", "Doing", "orange", "purple", "red", "sky", "Completed", "lime", "pink", "mauve"],
        :colors=>["#fad900", "#41c200", "#0079bf", "#ff9f19", "#a632db", "#f54747", "#00c2e0", "#4d4d4d", "#45e660", "#ff78cb", "#b3b3b3"],
        :counts=>[2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      })
    end
  end
end
