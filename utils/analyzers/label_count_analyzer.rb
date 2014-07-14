class LabelCountAnalyzer
  def self.analyze(raw)
    return {} if raw.nil? || raw.empty?

    data = JSON.parse(raw)

    return {} if data.empty?

    label_hash = {}
    data["labelNames"].each do |color, name|
      unless name.nil? || name.empty?
        label_hash[color] = {name: name, count: 0}
      end
    end

    data["cards"].each do |card|
      card["labels"].each do |label|
        label_hash[label["color"]][:count] += 1
      end
    end

    sorted_labels = label_hash.sort_by {|k, v| v[:count]}.reverse

    {
      labels: sorted_labels.map {|label| label[1][:name]},
      counts: sorted_labels.map {|label| label[1][:count]},
      colors: sorted_labels.map {|label| convert_color(label[0])}
    }
  end

  private

  def self.convert_color(color)
    case color
      when "green"
       '#34b27d'
      when "yellow"
        '#dbdb57'
      when "orange"
        '#e09952'
      when "red"
        '#cb4d4d'
      when "purple"
        '#93c'
      when "blue"
        '#4d77cb'
      end
  end
end