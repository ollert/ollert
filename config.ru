require './web'

if ENV['RACK_ENV'] == 'production'
  use Rack::Rewrite do
    r301 %r{.*}, 'https://ollertapp.com$&', :if => Proc.new {|rack_env|
      rack_env['SERVER_NAME'] != 'ollertapp.com'
    }
  end
end

run Ollert
