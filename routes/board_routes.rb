require 'trello'

class Ollert
  get '/boards', :auth => :none do
    if !@user.nil? && !@user.member_token.nil?
      session[:token] = @user.member_token
    elsif !params[:token].nil? && !params[:token].empty?
      session[:token] = params[:token]
    else
      flash[:info] = "Log in or connect with Trello to analyze your boards."
      redirect '/'
    end

    token, client = get_trello_object session[:token], :token, session[:token], nil, @user
    member = token.member

    # this logic needs to be fixed - why does this belong here?
    unless @user.nil?
      @user.member_token = session[:token]
      @user.trello_name = member.attributes[:username]
      @user.save
    end
    
    # change this to be async
    @boards = get_user_boards member

    haml_view_model :boards, @user
  end

  get '/boards/:id', :auth => :token do |board_id|
    # this call should be able to be pared down to just a call to get the boards
    token, @client = get_trello_object session[:token], :token, session[:token], nil, @user
    @boards = get_user_boards token.member

    @board_name = @boards.values.flatten.select {|x| x.id == board_id}.first.attributes[:name]
    @board_id = board_id

    haml_view_model :analysis, @user
  end
end
