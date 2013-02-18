require 'webmock/rspec'
require_relative '../lib/liftapp-client.rb'

describe Liftapp::Client do

  it 'returns profile_hash' do
    stub_request(:get, "https://neo@matrix.com:whiterabbit@www.lift.do/i/0/users/current").
      to_return(File.new(File.expand_path File.dirname(__FILE__) + '/fixtures/current'))

    client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
    expect(client.profile_hash).to eq 'e7fcd2db926273e895ef'
  end

  it 'returns habit list' do
    stub_request(:get, "https://neo@matrix.com:whiterabbit@www.lift.do/i/0/users/current").
      to_return(File.new(File.expand_path File.dirname(__FILE__) + '/fixtures/current'))
    stub_request(:get, "https://neo@matrix.com:whiterabbit@www.lift.do/api/v2/dashboard").
      to_return(File.new(File.expand_path File.dirname(__FILE__) + '/fixtures/dashboard'))

    client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
    expect(client.dashboard['subscriptions'].length).to eq 7
  end

  it 'returns checkin data' do
    stub_request(:get, "https://neo@matrix.com:whiterabbit@www.lift.do/i/0/users/current").
      to_return(File.new(File.expand_path File.dirname(__FILE__) + '/fixtures/current'))
    stub_request(:get, "https://www.lift.do/users/e7fcd2db926273e895ef/3280").
      to_return(File.new(File.expand_path File.dirname(__FILE__) + '/fixtures/3280'))

    client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
    data = client.checkin_data('3280')
    data['checkins'].length.should be > 10
    data['habit-name'].should eq 'Write'
  end

  it 'returns successful checkin' do
    stub_request(:get, "https://neo@matrix.com:whiterabbit@www.lift.do/i/0/users/current").
      to_return(File.new(File.expand_path File.dirname(__FILE__) + '/fixtures/current'))
    stub_request(:post, 'https://neo@matrix.com:whiterabbit@www.lift.do/api/v1/checkins').
      to_return(File.new(File.expand_path File.dirname(__FILE__) + '/fixtures/checkin'))

    client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
    data = client.checkin('2111')
    data['checkin']['id'].should be > 0
  end

end
