require 'trello'

class Ollert
  post '/trello/connect' do
    client = Trello::Client.new(
      :developer_public_key => ENV['PUBLIC_KEY'],
      :member_token => params[:token]
    )

    begin
      member = client.get("/tokens/#{params[:token]}/member",
        {
          fields: :username
        }
      )

      session[:token] = params[:token]
      session[:trello_name] = JSON.parse(member)["username"]

      status 200
    rescue Trello::Error => e
      body "There's something wrong with the Trello connection. Please re-establish the connection."
      status 500
    end
  end
end