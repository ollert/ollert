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

      expect(LabelCountAnalyzer.analyze(cards)).to match(
        labels: %w(yellow Completed Doing green lime mauve orange pink purple red sky),
        colors: %w(#fad900 #4d4d4d #0079bf #41c200 #45e660 #b3b3b3 #ff9f19 #ff78cb #a632db #f54747 #00c2e0),
        counts: [2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      )
    end
  end
end
