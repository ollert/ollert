class CfdAnalyzer
  def self.analyze(raw)
    return {} if raw.nil? || raw.empty?
    data = JSON.parse(raw)
    return {} if data.empty?

    actions = data["actions"]
    card_actions = actions.reject {|action| action["type"] == "updateList"}
    list_actions = actions.select {|action| action["type"] == "updateList"}

    # open lists
    lists = data["lists"].select { |x| !x["closed"]}

    # closed lists
    closed_lists = {}
    if list_actions.any?
      data["lists"].select { |x| x["closed"]}.each do |list|
        closed_lists[list["id"]] = Date.parse(list_actions.select {|action| action["data"]["list"]["id"] == list["id"]}.first["date"])
      end
    end

    format(build(card_actions, lists, closed_lists), lists)
  end

  private

  def self.build(card_actions, open_lists, closed_lists)
    cfd = Hash.new do |h, k|
      h[k] = Hash[open_lists.collect { |list| [list["name"], 0] }]
    end

    card_actions.group_by {|a| a["data"]["card"]["id"]}.each do |card, actions|
      30.days.ago.to_date.upto(Date.today).reverse_each do |date|
        my_actions = actions.reject {|a| a["date"].to_date > date}
        my_actions.sort_by! {|a| a["date"]}
        my_actions.reverse.each do |action|
          data = action["data"]
          if action["type"] == "updateCard"
            list = data["listAfter"]
          elsif action["type"] == "createCard"
            list = data["list"]
          end

          matching_list = open_lists.select {|l| l["id"] == list["id"]}.first
          break if matching_list.nil?
          name = matching_list["name"]
          break if !closed_lists[list["id"]].nil? && closed_lists[list["id"]].to_date < date
          cfd[date][name] += 1
          break
        end
      end
    end
    
    cfd
  end

  def self.format(cfd, lists)
    dates = cfd.keys.sort
    cfd_values = Array.new
    lists.each do |list|
      list_array = Array.new
      dates.each do |date|
        list_array << cfd[date][list["name"]]
      end
      cfd_values << { name: list["name"], data: list_array}
    end

    dates.map! {|date| date.strftime("%b %-d")}

    {
      dates: dates,
      cfddata: cfd_values
    }
  end
end