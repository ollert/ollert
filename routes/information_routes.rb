class Ollert
  get '/', :auth => :none do
    if !@user.nil? && !@user.member_token.nil?
      redirect '/boards'
    end
    
    haml :landing
  end

  # @todo: remove
  get '/symbols', :auth => :none do
    data = {symbols: Symbol.all_symbols.count}
    body data.to_json
    status 200
  end

  not_found do
    flash[:error] = "The page requested could not be found."
    redirect '/'
  end
end
