require 'sass'

class Ollert
  get '/privacy', :auth => :none do
    haml_view_model :privacy, @user
  end

  get '/terms', :auth => :none do
    haml_view_model :terms, @user
  end

  get '/styles.css' do
    scss :styles
  end
end
