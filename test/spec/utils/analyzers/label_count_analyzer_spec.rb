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
      expect(LabelCountAnalyzer.analyze("[]")).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(LabelCountAnalyzer.analyze("{}")).to be_empty
    end

    it 'returns labels, colors, and counts' do
      raw = '{"id":"52d01ea35592096d7e24fd0f",' +
            '"labelNames":{"yellow":"Spring","red":"Summer","purple":"","orange":"Winter","green":"Anytime","blue":"Nice-To-Haves"},' +
            '"cards":[{"id":"52d0a7ade32bfbcf06b5aed6","labels":[{"color":"green","name":"Anytime"}]},' +
            '{"id":"52d01f282ffa9f613d000607","labels":[{"color":"yellow","name":"Spring"}]},' +
            '{"id":"52d01f9b4546e0ee10b1c919","labels":[{"color":"red","name":"Summer"},{"color":"yellow","name":"Spring"}]},' +
            '{"id":"52d01fb64b46b82f5686b091","labels":[{"color":"purple","name":""},{"color":"yellow","name":"Spring"},{"color":"orange","name":"Winter"}]},' +
            '{"id":"52f0120ce2ca1d2051be5365","labels":[{"color":"orange","name":"Winter"}]},' +
            '{"id":"52d01fc01a2c5c6e119f850e","labels":[{"color":"yellow","name":"Spring"}]},' +
            '{"id":"52f011e0d1987a7b51a06e39","labels":[{"color":"red","name":"Summer"}]}]}'

      expect(LabelCountAnalyzer.analyze(raw)).to match({
        labels: ["Spring", "Winter", "Summer", "Anytime", "purple", "Nice-To-Haves"],
        counts: [4, 2, 2, 1, 1, 0],
        colors: ["#dbdb57", "#e09952", "#cb4d4d", "#34b27d", "#93c", "#4d77cb"]
      })
    end
  end
end