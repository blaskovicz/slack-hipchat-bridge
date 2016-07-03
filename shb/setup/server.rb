require 'sinatra/base'
server = Sinatra.new do
  get '/' do
    'SUCCESS'
  end
  get '/info' do
    slack2hipchat_room_map.inspect
  end
end

$children << Thread.new { server.run! }
