require_relative '../../../../utils/analyzers/wip_analyzer'

describe WipAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(WipAnalyzer.analyze(nil)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(WipAnalyzer.analyze("")).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(WipAnalyzer.analyze("[]")).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(WipAnalyzer.analyze("{}")).to be_empty
    end

    it 'returns wip' do
      raw = '[{"id":"5352919ed45d47fd76cc3f1a","name":"To Do (sorted by priority)",' +
               '"closed":false,"idBoard":"5352919ed45d47fd76cc3f19","pos":16384,' +
               '"subscribed":false,"cards":[{"id":"535878f74c8cdf616ac19d77"},' +
               '{"id":"5352a949adeb791e28653cad"},{"id":"5352b97be53228082e3983c1"}]},' +
               '{"id":"5352919ed45d47fd76cc3f1b","name":"Doing","closed":false,' +
               '"idBoard":"5352919ed45d47fd76cc3f19","pos":32768,"subscribed":false,' +
               '"cards":[]},{"id":"5352919ed45d47fd76cc3f1c",' +
               '"name":"Done","closed":false,"idBoard":"5352919ed45d47fd76cc3f19",' +
               '"pos":49152,"subscribed":false,"cards":[{"id":"5351c35f1802100f77f838c6"}]}]'

      expect(WipAnalyzer.analyze(raw)).to match({
        :wipcategories => ["To Do (sorted by priority)", "Doing", "Done"],
        :wipdata => [3, 0, 1]
      })
    end
  end
end