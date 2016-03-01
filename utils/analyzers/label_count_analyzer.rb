class LabelCountAnalyzer
  def self.analyze(data)
    return {} if data.nil? || data.empty?


    labels = {labels: [], colors: [], counts: []}
    data.reject {|label| label["uses"] == 0 && label["name"].empty?}.each do |label|
      labels[:labels] << label['name']
      labels[:colors] << convert_color(label['color'])
      labels[:counts] << label['uses']
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
