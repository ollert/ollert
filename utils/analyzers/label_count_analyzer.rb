class LabelCountAnalyzer
  def self.analyze(data, show_archived)
    return {} if data.nil? || data.empty?

    cards = show_archived ? data
                          : data.select {|card| !card["closed"]}

    labels = {labels: [], colors: [], counts: []}
    cards.map {|card| card["labels"]}.flatten.group_by {|label| label["id"]}.sort_by {|id, uses| [-uses.count, (uses[0]['color'] || '').downcase]}.each do |id, uses|
      labels[:labels] << ((uses[0]["name"].nil? || uses[0]["name"].empty?) ? uses[0]["color"] : uses[0]["name"])
      labels[:colors] << convert_color(uses[0]["color"])
      labels[:counts] << uses.count
    end
    labels
  end

  private

  def self.convert_color(color)
    case color
      when "green"
       '#41c200'
      when "yellow"
        '#fad900'
      when "orange"
        '#ff9f19'
      when "red"
        '#f54747'
      when "purple"
        '#a632db'
      when "blue"
        '#0079bf'
      when 'sky'
        '#00c2e0'
      when "lime"
        '#45e660'
      when "pink"
        '#ff78cb'
      when "black"
        '#4d4d4d'
      else
        '#b3b3b3'
      end
  end
end
