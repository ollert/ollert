class MemberAnalyzer
  def self.analyze(raw)
    JSON.parse(raw)
  end
end