require_relative '../../../../utils/analyzers/member_analyzer'

describe MemberAnalyzer do
  describe '#analyze' do
    it 'returns empty hash for nil' do
      expect(MemberAnalyzer.analyze(nil)).to be_empty
    end

    it 'returns empty hash for empty string' do
      expect(MemberAnalyzer.analyze("")).to be_empty
    end

    it 'returns empty hash for empty array' do
      expect(MemberAnalyzer.analyze("[]")).to be_empty
    end

    it 'returns empty hash for empty object' do
      expect(MemberAnalyzer.analyze("{}")).to be_empty
    end

    it 'returns hash of users' do
      raw = '{"id":"d3912324fff","username":"mo_money_mo_problems"}'

      member = MemberAnalyzer.analyze(raw)

      expect(member).to match({"id" => "d3912324fff", "username" => "mo_money_mo_problems"})
    end
  end
end