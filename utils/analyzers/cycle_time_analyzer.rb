class CycleTimeAnalyzer
  def self.analyze(cards, startingList, endingList)
    return {} if cards.nil? || cards.empty?

    # startingListIndex = startingList.nil? || startingList.empty? ? 0 : lists.index{ |l| startingList == l["name"]}
    # endingListIndex = endingList.nil? || endingList.empty? ? lists.count - 1 : lists.index{ |l| endingList == l["name"]}

    cards.each do |card|
      card["actions"].each do |action|
        
      end
    end

    cards
  end
end