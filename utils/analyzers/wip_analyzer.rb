class WipAnalyzer
  def self.analyze(raw)
    return {} if raw.nil? || raw.empty?

    wip = {}
    data = JSON.parse(raw)

    return {} if data.empty?

    data.each do |list|
      wip[list["name"]] ||= list["cards"].count
    end

    {
      wipcategories: wip.keys,
      wipdata: wip.values
    }
  end
end