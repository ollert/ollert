class BoardDetailsAnalyzer
  def self.analyze(data)
    return {} if data.nil? || data.empty?

    {
      name: data["name"],
      lists: data["lists"].map { |list| {name: list["name"], id: list["id"]} }
    }
  end
end