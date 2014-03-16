require 'pry'

module OllertHelpers
  def get_client(public_key, token)
    Trello::Client.new(
      :developer_public_key => public_key,
      :member_token => token
    )
  end

  def get_members_per_card_data(cards)
    counts = cards.map{ |card| card.members.count }
    counts.reduce(:+).to_f / counts.size
  end

  def get_cfd_data(actions, cards, lists)
  	results = Hash.new do |hsh, key|
  		hsh[key] = Hash[lists.collect { |list| [list, 0] }] 
  	end
    actions.reject! {|a| a.type != "updateCard" && a.type != "createCard"}
    cards = actions.group_by {|a| a.data["card"]["name"]}
    cards.each do |card, actions|
      actions.sort_by! {|a| a.date}
  	  30.days.ago.to_date.upto(Date.today).reverse_each do |date|
        actions.reject! {|a| a.date.to_date > date}
        break if actions.empty?
        data = actions.last.data
        if data.keys.include? "listBefore"
          list = data["listBefore"]
        else
          list = data["list"]
        end
        results[date][list["name"]] += 1 unless list.nil?
  	  end
  	end
    results
  end
end
