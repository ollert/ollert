require_relative '../core_ext/string'

module OllertHelpers
  def get_user
    return session[:user].nil? ? nil : User.find(id: session[:user])
  end

  def get_membership_type(params)
    if params[:yearly] == "on"
        "yearly"
      elsif params[:monthly] == "on"
        "monthly"
      else
        "free"
      end
  end

  def get_client(public_key, token)
    Trello::Client.new(
      :developer_public_key => public_key,
      :member_token => token
    )
  end
  
  def get_stats(board)
    stats = Hash.new

    card_members_counts = board.cards.map{ |card| card.members.count }
    card_members_total = card_members_counts.reduce(:+).to_f
    stats[:avg_members_per_card] = get_avg_members_per_card(card_members_counts, card_members_total)
    stats[:avg_cards_per_member] = get_avg_cards_per_member(card_members_total, board.members)

    lists = board.lists
    stats[:list_with_most_cards] = get_list_with_most_cards(lists)
    stats[:list_with_least_cards] = get_list_with_least_cards(lists)
    
    stats[:board_members_count] = board.members.count
    stats[:card_count] = board.cards.count
    stats
  end

  def get_avg_members_per_card(card_members_counts, card_members_total)
    mpc = card_members_total / card_members_counts.size
    mpc.round(2)
  end

  def get_avg_cards_per_member(card_members_total, members)
    cpm = card_members_total / members.size
    cpm.round(2)
  end

  def get_list_with_most_cards(lists)
    lists.max_by{ |list| list.cards.count }
  end

  def get_list_with_least_cards(lists)
    lists.min_by{ |list| list.cards.count }
  end

  def haml_view_model(view, user = nil)
    haml view.to_sym, locals: {logged_in: !!user}
  end

  def validate_signup(params)
    msg = ""
    if params[:email].nil_or_empty?
      msg = "Please enter a valid email."
    elsif !User.find(email: params[:email]).nil?
      msg = "User with that email already exists."
    elsif params[:password].nil_or_empty?
      msg = "Please enter a valid password."
    elsif !params[:agreed]
      msg = "Please agree to our terms."
    end
    msg
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

  def get_label_count_data(cards)
    label_count = Hash.new

    cards.group_by{ |card| card.labels }.each do |label,card|
      unless label.nil?
        label_count[label.color] = card.count
      end
    end

    label_count
  end
end
