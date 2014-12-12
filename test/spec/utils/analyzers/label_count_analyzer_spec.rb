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

    it 'returns all the defined colors' do
      raw = '[{"id":"5463a60b74d650d567f7dbdd","color":"green","name":"Left","uses":48},' +
             '{"id":"5463a60b74d650d567f7dbdc","color":"yellow","name":"Right","uses":46},' +
             '{"id":"5463a60b74d650d567f7dbde","color":"purple","name":"Up","uses":21},' +
             '{"id":"5463a60b74d650d567f7dbdf","color":"orange","name":"Down","uses":13},' +
             '{"id":"5463a60b74d650d567f7dbe0","color":"red","name":"A","uses":8},' +
             '{"id":"5463a60b74d650d567f7dbe1","color":"purple","name":"B","uses":8},' +
             '{"id":"5463a60b74d650d567f7dbe2","color":"blue","name":"X","uses":3},' +
             '{"id":"5463a60b74d650d567f7dbe3","color":"sky","name":"Y","uses":1},' +
             '{"id":"5463a60b74d650d567f7dbe4","color":"lime","name":"L","uses":18},' +
             '{"id":"5463a60b74d650d567f7dbe5","color":"black","name":"R","uses":4},' +
             '{"id":"5463a60b74d650d567f7dbe1","color":"pink","name":"Z","uses":5}]'

      expect(LabelCountAnalyzer.analyze(JSON.parse(raw))).to match({
        labels: ["Left", "Right", "Up", "Down", "A", "B", "X", "Y", "L", "R", "Z"],
        counts: [48,46,21,13,8,8,3,1,18,4,5],
        colors: ["#41c200", "#fad900", "#a632db", "#ff9f19", "#f54747", "#a632db", "#0079bf", "#00c2e0", "#45e660", "#4d4d4d", "#ff78cb"]
      })
    end

    it 'discards labels with 0 counts and no names but keeps with names' do
      raw = '[{"id":"5463a60b74d650d567f7dbdd","color":"green","name":"Left","uses":48},' +
             '{"id":"5463a60b74d650d567f7dbdc","color":"yellow","name":"Right","uses":46},' +
             '{"id":"5463a60b74d650d567f7dbde","color":"purple","name":"Up","uses":0},' +
             '{"id":"5463a60b74d650d567f7dbdf","color":"orange","name":"Down","uses":13},' +
             '{"id":"5463a60b74d650d567f7dbe0","color":"red","name":"A","uses":8},' +
             '{"id":"5463a60b74d650d567f7dbe1","color":"purple","name":"","uses":0},' +
             '{"id":"5463a60b74d650d567f7dbe2","color":"blue","name":"X","uses":3},' +
             '{"id":"5463a60b74d650d567f7dbe3","color":"sky","name":"Y","uses":1},' +
             '{"id":"5463a60b74d650d567f7dbe4","color":"lime","name":"L","uses":18},' +
             '{"id":"5463a60b74d650d567f7dbe5","color":"black","name":"","uses":0},' +
             '{"id":"5463a60b74d650d567f7dbe1","color":"pink","name":"Z","uses":5}]'

      expect(LabelCountAnalyzer.analyze(JSON.parse(raw))).to match({
        labels: ["Left", "Right", "Up", "Down", "A", "X", "Y", "L", "Z"],
        counts: [48,46,0,13,8,3,1,18,5],
        colors: ["#41c200", "#fad900", "#a632db", "#ff9f19", "#f54747", "#0079bf", "#00c2e0", "#45e660", "#ff78cb"]
      })
    end

    it 'returns all undefined colors as grey' do
      raw = '[{"id":"5463a60b74d650d567f7dbdd","color":"green","name":"Left","uses":48},' +
             '{"id":"5463a60b74d650d567f7dbdc","color":"yellow","name":"Right","uses":46},' +
             '{"id":"5463a60b74d650d567f7dbe3","color":"","name":"Y","uses":1},' +
             '{"id":"5463a60b74d650d567f7dbe4","color":"","name":"L","uses":18},' +
             '{"id":"5463a60b74d650d567f7dbe1","color":"","name":"Z","uses":5}]'

      expect(LabelCountAnalyzer.analyze(JSON.parse(raw))).to match({
        labels: ["Left", "Right", "Y", "L", "Z"],
        counts: [48, 46, 1, 18, 5],
        colors: ["#41c200", "#fad900", "#b3b3b3", "#b3b3b3", "#b3b3b3"]
      })
    end
  end
end