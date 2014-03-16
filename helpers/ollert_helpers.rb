require_relative '../core_ext/string'
require 'pry'

module OllertHelpers
  def get_user
    return session[:user].nil? ? nil : User.find(id: session[:user])
  end

  def get_membership_type(params)
    if params[:yearly] == "on"
      "yearly"
    elsif params[:free] == "on"
      "free"
    else
      "monthly"
    end
  end

  def get_client(public_key, token)
    Trello::Client.new(
      :developer_public_key => public_key,
      :member_token => token
    )
  end
  
  def get_stats(board)
    members = board.members
    cards = board.cards
    lists = board.lists
    createCardActions = board.actions(filter: :createCard)

    stats = Hash.new

    card_members_counts = cards.map{ |card| card.members.count }
    card_members_total = card_members_counts.reduce(:+).to_f
    stats[:avg_members_per_card] = get_avg_members_per_card(card_members_counts, card_members_total)
    stats[:avg_cards_per_member] = get_avg_cards_per_member(card_members_total, members)


    lst_most_cards = get_list_with_most_cards(lists)
    
    lst_most_cards.name = lst_most_cards.name.length > 24 ? lst_most_cards.name[0..21] + "..." : lst_most_cards.name
    stats[:list_with_most_cards_name] = lst_most_cards.name
    stats[:list_with_most_cards_count] = lst_most_cards.cards.count
    
    lst_least_cards = get_list_with_least_cards(lists)
    lst_least_cards.name = lst_least_cards.name.length > 24 ? lst_least_cards.name[0..21] + "..." : lst_least_cards.name
    stats[:list_with_least_cards_name] = lst_least_cards.name
    stats[:list_with_least_cards_count] = lst_least_cards.cards.count
    
    stats[:board_members_count] = members.count
    stats[:card_count] = cards.count

    stats[:oldest_card] = createCardActions.min_by(&:date).data["card"]["name"]
    
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
    msg = validate_email(params[:email])
    if msg.empty?
      if params[:password].nil_or_empty?
        msg = "Please enter a valid password."
      elsif !params[:agreed]
        msg = "Please agree to our terms."
      end
    end
    msg
  end

  def validate_email(email)
    msg = ""
    if email.nil_or_empty?
      msg = "Please enter a valid email."
    elsif !User.find(email: email).nil?
      msg = "User with that email already exists."
    end
    msg
  end

  def get_cfd_data(actions, lists, closed_lists)
  	results = Hash.new do |hsh, key|
  		hsh[key] = Hash[lists.values.collect { |list| [list, 0] }] 
  	end

    actions.reject! {|a| a.type != "updateCard" && a.type != "createCard"}
    cards = actions.group_by {|a| a.data["card"]["id"]}
    cards.each do |card, actions|
      30.days.ago.to_date.upto(Date.today).reverse_each do |date|
        my_actions = actions.reject {|a| a.date.to_date > date}
        my_actions.sort_by! {|a| a.date}
        my_actions.reverse.each do |action|
          data = action.data
          if data.keys.include? "listAfter"
            list = data["listAfter"]
          else
            list = data["list"]
          end
          unless list.nil?
            name = lists[list["id"]]
            break if name.nil?
            break if !closed_lists[list["id"]].nil? && closed_lists[list["id"]].to_date < date
            results[date][name] += 1
            break
          end
        end  
  	  end
  	end
    results
  end

  def get_label_count_data(cards)
    labels_array = Array.new

    cards.group_by{ |card| card.labels }.each do |labels,card|
      labels.each do |label|
          labels_array << label
      end
    end

    label_counts = Hash.new

    labels_array.group_by{ |label| label.name }.each do |label,v|
      hexcolor = convert_color(v.first.color)

      label_counts[label] = { count: v.count, color: hexcolor }
    end

    data = { labels: label_counts.keys, counts: label_counts.values.map{ |x| x[:count] }, colors: label_counts.values.map{ |x| x[:color] } }
  end

  def convert_color(color)
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
  
  def get_user_boards(user, session, client=nil)

    token = client.find(:token, session[:token])
    member = token.member

    unless user.nil?
      user.member_token = session[:token]
      user.trello_name = member.username
      user.save
    end

    @boards = member.boards.group_by {|board| board.organization_id.nil? ? "Unassociated Boards" : board.organization.name}
  end
end
