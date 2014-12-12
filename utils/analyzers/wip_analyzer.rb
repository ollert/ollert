class WipAnalyzer
  def self.analyze(data)
    return {} if data.nil? || data.empty?

    wip = {}
    data.each do |list|
      wip[list["name"]] ||= list["cards"].count
    end

    {
      wipcategories: wip.keys,
      wipdata: wip.values
    }
  end
end
