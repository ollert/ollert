require 'sinatra'

class Ollert < Sinatra::Base
  get '/' do
    "Hello, Trello!"
  end
end
