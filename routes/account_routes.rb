require 'trello'

class Ollert
  post '/authenticate' do
    user = User.find_by email: params['email']
    if user.nil?
      flash[:warning] = "Email address #{params['email']} does not appear to be registered."
      redirect :login
    elsif !user.authenticate? params['password']
      flash[:warning] = "I didn't find that username/password combination. Check your spelling."
      redirect :login
    else
      flash[:success] = "Welcome back."
      session[:user] = user.id
      redirect '/'
    end
  end

  get '/signup' do
    haml_view_model :signup, @user
  end

  post '/signup' do
    user = User.new :email => params[:email]
    user.password = params[:password]

    if params[:agreed] && user.save
      session[:user] = user.id
      flash[:success] = "You're signed up! Click below to connect with Trello for the first time."
      redirect '/'
    else
      @email = params[:email]
      if !params[:agreed]
        flash[:error] = "Please agree to the terms of service."
      elsif user.errors.any?
        error_list = ""
        user.errors.full_messages.each { |x| error_list << "<li>#{x}</li>" }
        flash[:error] = "Registration failed: <ul>#{error_list}</ul>"
      else
        flash[:error] = "Something's broken, please try again later."
      end
      
      haml_view_model :signup
    end
  end

  get '/login' do
    haml_view_model :login
  end

  post '/logout', :auth => :authenticated do
    session[:user] = nil
    session[:token] = nil
    flash[:success] = "Come see us again soon!"

    redirect '/'
  end

  put '/settings/trello/disconnect', :auth => :authenticated do
    @user.member_token = nil
    @user.trello_name = nil

    if !@user.save
      status 500
    end

    status 200
  end

  put '/settings/trello/connect', :auth => :authenticated do
    session[:token] = params[:token]

    client = get_client ENV['PUBLIC_KEY'], session[:token]

    token = client.find(:token, session[:token])
    member = token.member

    @user.member_token = session[:token]
    @user.trello_name = member.attributes[:username]

    if !@user.save
      status 500
      body "Failed to save connection."
    else
      status 200
      body @user.trello_name
    end
  end

  put '/settings/email', :auth => :authenticated do
    @user.email = params[:email]

    if @user.save
      body @user.email
      status 200
    else
      status 500
      if @user.errors.any?
        body "Save failed: #{@user.errors.full_messages.join(", ")}"
      else
        body "Save failed."
      end
    end
  end

  put '/settings/password', :auth => :authenticated do
    result = @user.change_password params[:current_password],
                               params[:new_password],
                               params[:confirm_password]
    if result[:status]
      if !@user.save
        if @user.errors.any?
          body "Save failed: #{user.errors.full_messages.join(", ")}"
          status 500
        else
          body "Save failed."
          status 500
        end
      else
        body "Password updated."
        status 200
      end
    else
      body result[:message]
      status 500
    end
  end

  post '/settings/delete', :auth => :authenticated do
    if params[:iamsure] == "on"
      email = @user.email

      session[:user] = nil
      session[:token] = nil
      if @user.delete
        flash[:success] = "User with login of #{email} has been deleted. Come back and sign up again one day!"
        redirect '/'
      else
        flash[:error] = "I wasn't able to delete that user. Do you mind trying again?"
        redirect '/settings'
      end
    else
      flash[:warning] = "You must check the 'I am sure' checkbox to delete your account."
      redirect '/settings'
    end
  end

  get '/settings', :auth => :authenticated do
    haml_view_model :settings, @user
  end
end