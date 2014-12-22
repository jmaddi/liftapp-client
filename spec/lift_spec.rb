require 'webmock/rspec'
require 'spec_helper'
require_relative '../lib/liftapp-client.rb'

describe Liftapp::Client do

  it 'returns profile_hash' do
    client = Liftapp::Client.new('peterpan@neverland.com', 'neverland')
    expect(client.profile_hash).to eq 'e7fcd2db926273e895ef'
  end

  it 'returns habit list' do
    client = Liftapp::Client.new('peterpan@neverland.com', 'neverland')
    expect(client.dashboard['subscriptions'].length).to eq 3
  end

  it 'returns checkin data' do
    client = Liftapp::Client.new('peterpan@neverland.com', 'neverland')
    data = client.checkin_data('2925')
    expect(data['checkins'].length).to eq 2
    expect(data['habit-name']).to eq 'Cook'
  end

  it 'returns successful checkin' do
    client = Liftapp::Client.new('peterpan@neverland.com', 'neverland')
    data = client.checkin('23946', nil)
    expect(data['checkin']['id']).to be > 0
  end

  it 'sets name and picture_url' do
    client = Liftapp::Client.new('peterpan@neverland.com', 'neverland')
    expect(client.picture_url).to eq 'http://profile.ak.fbcdn.net/hprofile-ak-snc6/260854_100003561549613_94631864_q.jpg'
    expect(client.name).to eq 'Peter Pan'
  end

end
