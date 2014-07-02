require 'trello'

class Ollert
  post '/authenticate' do
    user = User.find_by email: params['email']
    if user.nil?
      body "Login failed: Incorrect email."
      status 500
    elsif !user.authenticate? params['password']
      body "Login failed: Incorrect password."
      status 500
    else
      session[:user] = user.id
      status 200
    end
  end

  get '/signup' do
    @signing_up = true
    haml_view_model :signup, @user
  end

  post '/signup' do
    user = User.new :email => params[:email]
    user.password = params[:password]

    if params[:agreed] != "true"
      status 500
      body "Registration failed: Please agree to the terms of service."
    elsif user.save
      session[:user] = user.id
      status 200
    else
      status 500
      if user.errors.any?
        body "Registration failed: #{user.errors.full_messages.join(", ")}"
      else
        body "Registration failed."
      end
    end
  end

  get '/login' do
    @signing_up = false
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
      body "Save failed: " + result[:message]
      status 500
    end
  end

  delete '/settings/delete', :auth => :authenticated do
    if params[:iamsure] == "true"
      if @user.delete
        session[:user] = nil
        session[:token] = nil

        status 200
      else
        if @user.errors.any?
          body "Delete failed: #{@user.errors.full_messages.join(", ")}"
        else
          body "Delete failed."
        end
        status 500
      end
    else
      body "Delete failed: Check the 'I am sure' checkbox to confirm deletion."
      status 500
    end
  end

  get '/settings', :auth => :authenticated do
    haml_view_model :settings, @user
  end
end