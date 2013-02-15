require 'sinatra'
require 'coffee-script'
require 'liftapp-client'

configure do
  mime_type :plain, 'text/plain'
end

get '/' do
  haml :index
end

post '/dashboard.json' do
  client = Liftapp::Client.new(email: params[:email], password: params[:password])
  content_type :json
  client.dashboard.to_json
end

get '/checkins/:user/:habit' do
  content_type :plain
  client = Liftapp::Client.new(profile_hash: params[:user])
  data   = client.checkin_data(params[:habit])
  output = data[:checkins].map { |d| d.strftime('%Y-%m-%d') }
  output.unshift data[:'habit-name']
  output.join("\n")
end

get '/application.js' do
  coffee :application
end
