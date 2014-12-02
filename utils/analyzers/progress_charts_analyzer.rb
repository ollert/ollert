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

    cfdData = parse(data, lists, action_fetcher)

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

  def self.parse(data, lists, action_fetcher)
    actions = data["actions"]

    fetched = actions.count
    while fetched == 1000
      new_actions = JSON.parse(action_fetcher.call(actions.last["date"]))
      fetched = new_actions.count
      actions.concat new_actions
    end

    card_actions = actions.reject {|action| action["type"] == "updateList"}
    list_actions = actions.select {|action| action["type"] == "updateList"}

    # open lists
    lists = data["lists"].select { |x| !x["closed"]}

    card_actions = actions.reject {|action| action["type"] == "updateList"}

    build(card_actions, lists)
  end

  def self.build(card_actions, open_lists)
    now = Time.now
    cfd = Hash.new do |h, k|
      h[k] = Hash[open_lists.collect { |list| [list["name"], []] }]
    end

    isFirst = true
    cad = card_actions.group_by {|ca| ca["date"].to_date}
    return cfd if cad.empty?
    cad.keys.min.upto(Date.today).each do |date|
      cfd[date-1].each do |k,v|
        cfd[date][k] = v.clone
      end unless isFirst
      isFirst = false

      next if cad[date].nil?
      cad[date].sort_by {|c| c["date"].to_datetime}.each do |action|
        data = action["data"]

        if action["type"] == "updateCard" && !data["listAfter"].nil? && !data["listBefore"].nil?
          list = data["listAfter"]

          matching_list = open_lists.select {|l| l["id"] == data["listBefore"]["id"]}.first
          unless matching_list.nil?
            cfd[date][matching_list["name"]].delete data["card"]["id"]
          end
        elsif action["type"] == "createCard"
          list = data["list"]
        else
          # card was closed
          list = cfd[date].select {|k,v| v.any? {|cid| cid == data["card"]["id"]}}
          unless list.nil? || list.count != 1
            cfd[date][list.keys.first].delete data["card"]["id"]
          end
          next
        end

        matching_list = open_lists.select {|l| l["id"] == list["id"]}.first
        next if matching_list.nil?
        next if cfd[date][matching_list["name"]].include? action["data"]["card"]["id"]
        cfd[date][matching_list["name"]] << action["data"]["card"]["id"]
      end
    end

    cfd.each {|k,v| v.each {|l,c| cfd[k][l] = c.count}}

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
