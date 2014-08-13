class Ollert
  get '/', :auth => :none do
    if !@user.nil? && !@user.member_token.nil?
      puts "redirect to boards"
      redirect '/boards'
    end
    
    haml :landing
  end

  not_found do
    flash[:error] = "The page requested could not be found."
    redirect '/'
  end
end