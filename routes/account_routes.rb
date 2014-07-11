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
      session[:token] = user.member_token
      status 200
    end
  end

  get '/signup' do
    @signing_up = true
    haml :signup
  end

  post '/signup' do
    user = User.new :email => params[:email]
    user.password = params[:password]

    if params[:agreed] != "true"
      status 500
      body "Registration failed: Please agree to the terms of service."
    elsif user.save
      session[:user] = user.id
      flash[:success] = "You're signed up! Connect to Trello to get started."
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
    haml :login
  end

  post '/logout', :auth => :authenticated do
    session[:user] = nil
    session[:token] = nil
    flash[:success] = "Come see us again soon!"

    redirect '/'
  end

  put '/settings/trello/disconnect', :auth => :authenticated do
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => @user.member_token
    )

    begin
      client.delete("/tokens/#{@user.member_token}")
    rescue Trello::Error => e
      # this probably means the token was revoked on Trello
      # which is fine and we don't need to do anything about it
    end

    @user.member_token = nil
    @user.trello_name = nil

    if !@user.save
      status 500
    end

    status 200
  end

  put '/settings/trello/connect', :auth => :authenticated do
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params[:token]
    )

    begin
      member = MemberAnalyzer.analyze(MemberFetcher.fetch(client, params[:token]))

      session[:token] = params[:token]
      session[:trello_name] = member["username"]

      @user.member_token = session[:token]
      @user.trello_name = session[:trello_name]

      if !@user.save
        status 500
        body "Failed to save connection."
      else
        body @user.trello_name
        status 200
      end
    rescue Trello::Error => e
      body "There's something wrong with the Trello connection. Please re-establish the connection."
      status 500
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

  put '/account/reset' do
    if !params[:username].nil? && !params[:username].empty?
      user = User.find_by(email: params[:username])
      if !user.nil?
        url = "#{request.base_url}/account/reset/#{user.reset_password}"
        Pony.mail(
          to: params[:username],
          from: "Ollert Help Desk <noreply@ollertapp.com>",
          subject: "Ollert Password Reset Notification",
          body: "A request has been made to reset password for your Ollert account (https://ollertapp.com)." +
                "If you made this request, go to " + url + ". If you did not make this request, ignore this email.",
          html_body: haml(
            :reset_password_email,
            layout: false,
            locals: {
              email: params[:username],
              date: DateTime.now.strftime("%H:%M:%S%P %B %d, %Y"),
              ip: request.ip,
              reset_url: url
            }
          )
        )

        status 200
      else
        body "No matching user for #{params[:username]}. Sign up to create an account."
        status 500
      end
    else
      body "Invalid username."
      status 500
    end
  end

  get '/account/reset/:secret' do |secret|
    user = User.find_by("password_reset.reset_hash" => secret)
    if user.nil?
      flash[:error] = "Invalid reset hash. Please try again."
      redirect :login
    elsif user.password_reset.nil? || user.password_reset.expired?
      user.password_reset = nil
      user.save!

      flash[:error] = "Password reset time period has expired. Please try again."
      redirect :login
    else
      @email = user.email
      @secret = params[:secret]
      haml :reset_password
    end
  end

  post '/account/reset/:secret' do |secret|
    user = User.find_by("password_reset.reset_hash" => secret)
    if user.nil?
      flash[:error] = "Password reset time period has expired. Please try again."
      redirect :login
    elsif user.password_reset.nil? || user.password_reset.expired?
      user.password_reset = nil
      user.save!

      flash[:error] = "Password reset time period has expired. Please try again."
      redirect :login
    else
      user.password = params[:password]
      user.password_reset = nil
      if !user.save
        flash[:error] = "Save failed: #{user.errors.full_messages.join(", ")}"
        redirect :login
      else
        session[:user] = user.id
        redirect '/'
      end
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
    haml :settings
  end
end