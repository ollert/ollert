require 'trello'

require_relative '../utils/connecting/user_connector'

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
        # log out
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
    result = UserConnector.connect ENV['PUBLIC_KEY'], params[:token]

    session[:user] = result[:id]
    status result[:status]
    body result[:body]
  end

  put '/settings/trello/connect', auth: :connected do
    result = UserConnector.connect ENV['PUBLIC_KEY'], params[:token], @user
    
    session[:user] = result[:id]
    status result[:status]
    body result[:body]
  end
end