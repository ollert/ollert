class Ollert
  get '/boards/:board_id/analysis/wip' do |board_id|
    @board, _ = get_trello_object session[:token], :board, board_id, @client, @user

    @wip_data = Hash.new
    options = {limit: 999}
    cards = @board.cards options
    lists = @board.lists(filter: :all)
    actions = @board.actions options
    
    cards.group_by { |x| x.list.name }.each_pair do |k,v|
      @wip_data[k] = v.count
    end

    data = { wipcategories: @wip_data.keys, wipdata: @wip_data.values }
    
    data.to_json
  end

  get '/boards/:id/analysis/cfd' do |board_id|
    board, _ = get_trello_object session[:token], :board, board_id, @client, @user

    # might be faster to just get lists and actions without getting the board
    lists = board.lists(filter: :all)
    actions = board.actions(limit: 999)
    closed_lists = Hash.new
    lists.select {|l| l.closed}.each do |l|
      closed_lists[l.id] = l.actions.first.date
    end

    list_ids_to_names = Hash.new
    lists.each do |list|
      list_ids_to_names[list.id] = list.name
    end

    cfd_data = get_cfd_data(actions, list_ids_to_names, closed_lists)
    dates = cfd_data.keys.sort
    cfd_values = Array.new
    lists.collect(&:name).uniq.each do |list|
      list_array = Array.new
      dates.each do |date|
        list_array << cfd_data[date][list]
      end
      cfd_values << { name: list, data: list_array}
    end

    dates.map! {|date| date.strftime("%b %-d")}

    data = { dates: dates, cfddata: cfd_values}

    data.to_json
  end
  
  get '/boards/:id/analysis/stats' do |board_id|
    board, _ = get_trello_object session[:token], :board, board_id, @client, @user
    @stats = get_stats(board)
    @stats.to_json
  end
  
  get '/boards/:id/analysis/labelcounts' do |board_id|
    @board, _ = get_trello_object session[:token], :board, board_id, @client, @user
    @label_count_data = get_label_count_data(@board.cards)
    @label_count_data.to_json
  end
end
