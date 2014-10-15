class BoardDetailsAnalyzer
  def self.analyze(raw)
    return {} if raw.nil? || raw.empty?

    data = JSON.parse(raw)

    return {} if data.empty?

    {
      name: data["name"],
      lists: data["lists"].map { |list| list["name"] }
    }
  end
end
