class MemberAnalyzer
  def self.analyze(raw)
    return {} if raw.nil? || raw.empty?
    JSON.parse(raw)
  end
end