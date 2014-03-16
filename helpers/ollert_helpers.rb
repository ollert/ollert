require_relative '../core_ext/string'

module OllertHelpers
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

  def haml_view_model(view, locals = {})
    default_locals = {logged_in: false}
    locals = default_locals.merge locals
    haml view.to_sym, locals => locals
  end

  def validate_signup(params)
    msg = ""
    if params[:email].nil_or_empty?
      msg = "Please enter a valid email."
    elsif params[:password].nil_or_empty?
      msg = "Please enter a valid password."
    elsif !params[:agreed]
      msg = "Please agree to our terms."
    elsif !params[:membership].nil?
      msg = "Please select a membership type."
    end
    msg
  end
end
