require 'trello'

class Ollert
  get '/logout', :auth => :connected do
    session[:user] = nil

    flash[:success] = "Successfully logged out."
    redirect '/'
  end

  put '/settings/email', :auth => :connected do
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

  delete '/settings/delete', :auth => :connected do
    if params[:iamsure] == "true"
      unless @user.trello_name.nil? || @user.member_token.nil?
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
      end

      if @user.delete
        session[:user] = nil

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

  get '/settings', :auth => :connected do
    unless @user.member_token.nil? || @user.trello_name.nil?
      client = Trello::Client.new(
        :developer_public_key => ENV['PUBLIC_KEY'],
        :member_token => @user.member_token
      )

      begin
        @boards = BoardAnalyzer.analyze(BoardFetcher.fetch(client, @user.trello_name))
      rescue Trello::Error => e
        @user.member_token = nil
        @user.trello_name = nil
        @user.save
      end
    end

    haml :settings
  end

  put '/trello/connect' do
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params[:token]
    )

    begin
      member = MemberAnalyzer.analyze(MemberFetcher.fetch(client, params[:token]))

      user = User.find_or_initialize_by trello_id: member["id"]

      unless user.member_token.nil? || user.member_token == params[:token]
        begin
          client.delete("/tokens/#{user.member_token}")
        rescue
          # do nothing
          # most likely token either expired or was revoked
        end
      end

      user.member_token = params[:token]
      user.trello_id = member["id"]
      user.trello_name = member["username"]
      user.gravatar_hash = member["gravatarHash"]
      user.email = member["email"] || user.email
      user.save

      # log in
      session[:user] = user.id

      status 200
    rescue Trello::Error => e
      body "There's something wrong with the Trello connection. Please re-establish the connection."
      status 500
    end
  end

  put '/settings/trello/connect', auth: :connected do
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params[:token]
    )

    begin
      member = MemberAnalyzer.analyze(MemberFetcher.fetch(client, params[:token]))

      if member["id"] != @user.trello_id && !User.find_by(trello_id: member["id"]).nil?
        body "User already exists using that account. Log out to connect with that account."
        status 500
        return
      end

      unless @user.member_token.nil? || @user.member_token == params[:token]
        begin
          client.delete("/tokens/#{@user.member_token}")
        rescue
          # do nothing
          # most likely token either expired or was revoked
        end
      end

      @user.member_token = params[:token]
      @user.trello_id = member["id"]
      @user.trello_name = member["username"]
      @user.gravatar_hash = member["gravatarHash"]
      @user.email = member["email"] || @user.email
      @user.save

      body {{username: member["username"], gravatar_hash: member["gravatarHash"]}.to_json}
      status 200
    rescue Trello::Error => e
      body "There's something wrong with the Trello connection. Please re-establish the connection."
      status 500
    end
  end
end