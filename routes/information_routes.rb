class Ollert
  get '/', :auth => :none do
    if !@user.nil? && !@user.member_token.nil?
      redirect '/boards'
    end
    
    haml_view_model :landing, @user
  end

  not_found do
    flash[:error] = "The page requested could not be found."
    redirect '/'
  end
end
