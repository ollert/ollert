class WipAnalyzer
  def self.analyze(raw)
    wip = {}
    JSON.parse(raw).each do |list|
      wip[list["name"]] ||= list["cards"].count
    end

    {
      wipcategories: wip.keys,
      wipdata: wip.values
    }
  end
end