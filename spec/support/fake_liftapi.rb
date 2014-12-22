require 'sinatra'


class FakeLiftAPI < Sinatra::Base
  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['peterpan%40neverland.com', 'neverland']
    end
  end

  get '/i/0/users/current' do
    protected!
    json_response 200, 'current.json'
  end

  get '/api/v4/dashboard' do
    protected!
    json_response 200, 'dashboard.json'
  end

  post '/api/v3/checkins' do
    protected!
    json_response 200, 'create_checkin.json'
  end

  delete '/api/v3/checkins' do
    protected!
    json_response 200, 'delete_checkin.json'
  end

  get '/users/:profile_hash/:habit_id' do
    html_response 200, 'checkin_data.html'
  end

  private

  def html_response(response_code, file_name)
    content_type :html
    status response_code
    File.open(File.join(File.dirname(__FILE__), '../fixtures/', file_name), 'rb').read
  end

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.join(File.dirname(__FILE__), '../fixtures/', file_name), 'rb').read
  end
end
