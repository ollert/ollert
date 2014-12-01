class LabelCountAnalyzer
  def self.analyze(raw)
    return {} if raw.nil? || raw.empty?
    data = JSON.parse(raw)
    return {} if data.empty?
    
    labels = data.reject {|label| label["uses"] == 0 && label["name"].empty?}

    {
      labels: labels.map {|label| label["name"]},
      counts: labels.map {|label| label["uses"]},
      colors: labels.map {|label| convert_color(label["color"])}
    }
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