require 'sinatra'
require 'haml'

class Ollert < Sinatra::Base
  get '/' do
    haml :landing
  end
end
