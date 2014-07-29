require 'pry'
require 'date'

class CfdAnalyzer
  def self.analyze(raw, action_fetcher, parameters = {})
    return {} if raw.nil? || raw.empty?
    data = JSON.parse(raw)
    return {} if data.empty?

    actions = data["actions"]

    fetched = actions.count
    while fetched == 1000
      new_actions = JSON.parse(action_fetcher.call(actions.last["date"], parameters))
      fetched = new_actions.count
      actions.concat new_actions
    end

    # pare actions by date (if parameters exist)
    actions.reject! do |action|
      DateTime.parse(action["date"]) < parameters[:date_from]
    end if parameters[:date_from]
    actions.reject! do |action|
      parameters[:date_to] < DateTime.parse(action["date"])
    end if parameters[:date_to]

    card_actions = actions.reject {|action| action["type"] == "updateList"}
    list_actions = actions.select {|action| action["type"] == "updateList"}
    closed_actions = actions.select {|action| action["type"] == "updateList"}.group_by { |action| action["data"]["list"]["id"]}

    # open lists
    lists = data["lists"].select { |x| !x["closed"]}

    # closed lists
    closed_lists = {}
    closed_actions.each do |list, actions|
      closed_action = actions.max {|action| Date.parse(action["date"])}
      if closed_action["data"]["list"]["closed"]
        closed_lists[list] = closed_action["date"]
      end
    end

    card_actions = actions.reject {|action| action["type"] == "updateList"}
    lists = data["lists"].reject { |x| x["closed"]}

    format(build(card_actions, lists, closed_lists), lists)
  end

  private

  def self.build(card_actions, open_lists, closed_lists)
    cfd = Hash.new do |h, k|
      h[k] = Hash[open_lists.collect { |list| [list["name"], 0] }]
    end

    card_actions.group_by {|a| a["data"]["card"]["id"]}.each do |card, actions|
      earliest_date = actions.map{|a| a['date'].to_date}.min
      earliest_date.upto(Date.today).reverse_each do |date|
        my_actions = actions.reject {|a| a["date"].to_date > date}
        my_actions.sort_by! {|a| a["date"]}
        my_actions.reverse.each do |action|
          data = action["data"]
          if action["type"] == "updateCard" && !data["listAfter"].nil?
            list = data["listAfter"]
          elsif action["type"] == "createCard"
            list = data["list"]
          else
            # card is closed
            break
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
        list_array << [date.strftime('%s000').to_i, cfd[date][list["name"]]]
      end
      cfd_values << { name: list["name"], data: list_array}
    end

    {
      cfddata: cfd_values
    }
  end
end
