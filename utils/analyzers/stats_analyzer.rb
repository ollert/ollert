require 'date'

class StatsAnalyzer
  def self.analyze(data)
    return {} if data.nil? || data.empty?

    cards = data["cards"]
    members = data["members"]
    creations = data["actions"]
    lists = data["lists"]

    analyze_members(cards, members)
          .merge(analyze_cards(cards, creations))
          .merge(analyze_lists(cards, lists))
  end

  private

  def self.analyze_members(cards, members)
    {
      board_members_count: members.count,
      card_count: cards.count,
      avg_members_per_card: get_average_members_per_card(cards),
      avg_cards_per_member: get_average_cards_per_member(cards, members)
    }
  end

  def self.get_average_members_per_card(cards)
    (cards.reduce(0) {|sum, card| sum += card["idMembers"].count}.to_f / cards.count).round(2)
  end

  def self.get_average_cards_per_member(cards, members)
    members_per_card = Hash[ members.map {|member| [member["id"], 0]} ]
    cards.each do |card|
      card["idMembers"].each do |member|
        members_per_card[member] += 1 if members_per_card.has_key?(member)
      end
    end
    (members_per_card.values.reduce(:+).to_f / members.count).round(2)
  end

  def self.analyze_lists(cards, lists)
    max_name, max = get_list_with_most_cards(cards, lists)
    min_name, min = get_list_with_least_cards(cards, lists)

    {
      list_with_most_cards_name: max_name,
      list_with_most_cards_count: max,
      list_with_least_cards_name: min_name,
      list_with_least_cards_count: min
    }
  end

  def self.get_list_with_most_cards(cards, lists)
    counts = Hash.new(0)
    cards.each do |card|
      counts[card["idList"]] += 1
    end
    most = counts.max_by {|k, v| v}
    list = lists.select {|l| l["id"] == most[0]}.first unless most.nil?

    if list.nil?
      return "", 0
    end

    return list["name"], most[1]
  end

  def self.get_list_with_least_cards(cards, lists)
    counts = Hash[ lists.map {|list| [list["id"], 0]} ]
    cards.each do |card|
      counts[card["idList"]] += 1
    end
    least = counts.min_by {|k, v| v}
    list = lists.select {|l| l["id"] == least[0]}.first["name"] unless least.nil?

    if list.nil?
      return "", 0
    end

    return list, least[1]
  end

  def self.analyze_cards(cards, actions)
    oldest_name, oldest = get_oldest_card(cards, actions)
    newest_name, newest = get_newest_card(cards, actions)
    {
      oldest_card_name: oldest_name,
      oldest_card_age: oldest,
      newest_card_name: newest_name,
      newest_card_age: newest
    }
  end

  def self.get_oldest_card(cards, actions)
    oldest = actions.min_by { |action| action["date"].to_date }
    return oldest["data"]["card"]["name"], Date.today.mjd - oldest["date"].to_date.mjd unless oldest.nil?
  end

  def self.get_newest_card(cards, actions)
    oldest = actions.max_by { |action| action["date"].to_date }
    return oldest["data"]["card"]["name"], Date.today.mjd - oldest["date"].to_date.mjd unless oldest.nil?
  end
end
