class LabelCountAnalyzer
  def self.analyze(raw)
    data = JSON.parse(raw)

    label_counts = {}

    data["cards"].each do |card|
      card["labels"].each do |label|
        label_counts[label] ||= 0
        label_counts[label] += 1
      end
    end

    {
      labels: label_counts.keys.map {|label| label["name"]},
      counts: label_counts.values,
      colors: data["labelNames"].keys.map {|color| convert_color(color)}
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