require 'date'
require 'mongoid'

class ProgressChartsAnalyzer
  def self.analyze(raw, action_fetcher, startingList, endingList)
    return {} if raw.nil? || raw.empty?
    data = JSON.parse(raw)
    return {} if data.empty?

    # open lists
    lists = data["lists"].select { |x| !x["closed"]}

    startingListIndex = startingList.nil? || startingList.empty? ? 0 : lists.index{ |l| startingList == l["name"]}
    endingListIndex = endingList.nil? || endingList.empty? ? lists.count - 1 : lists.index{ |l| endingList == l["name"]}

    cfdData = parseCFDData(data, lists, action_fetcher)

    cfdData.reject do |date| 
      index = lists.index{ |l| cfdData[date]["name"] == l["name"]}
      !index.nil? && index >= startingListIndex && index < endingListIndex
    end

    {
      cfd: formatCFD(cfdData, lists[startingListIndex..endingListIndex]),
      burnup: formatBurnUp(cfdData, lists[startingListIndex..endingListIndex-1], lists[endingListIndex, lists.count-1])
    }
  end

  private

  def self.parseCFDData(data, lists, action_fetcher)
    actions = data["actions"]

    fetched = actions.count
    while fetched == 1000
      new_actions = JSON.parse(action_fetcher.call(actions.last["date"]))
      fetched = new_actions.count
      actions.concat new_actions
    end

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

    build(card_actions, lists, closed_lists)
  end

  # TODO: rewrite this - takes WAY TOO LONG
  def self.build(card_actions, open_lists, closed_lists)
    cfd = Hash.new do |h, k|
      h[k] = Hash[open_lists.collect { |list| [list["name"], 0] }]
    end

    card_actions.group_by {|a| a["data"]["card"]["id"]}.each do |card, actions|
      earliest_date = actions.map{|a| a['date'].to_date}.min
      Date.today.downto(earliest_date).each do |date|
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

  def self.formatCFD(cfd, lists)
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

  def self.formatBurnUp(cfd, inScopeLists, outOfScopeLists)
    dates = cfd.keys.sort
    cfd_values = Array.new
   
    inList_array = Array.new
    outList_array = Array.new
    dates.each do |date|
      inCount = 0
      outCount = 0

      inScopeLists.each do |list|
        inCount += cfd[date][list["name"]]
      end
      inList_array << [date.strftime('%s000').to_i, inCount]

      outOfScopeLists.each do |list|
        outCount += cfd[date][list["name"]]
      end
      outList_array << [date.strftime('%s000').to_i, outCount]
    end
    cfd_values << { name: "InScope", data: inList_array}
    cfd_values << { name: "Complete", data: outList_array}

    {
      cfddata: cfd_values
    }
  end
end
