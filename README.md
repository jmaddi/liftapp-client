# Liftapp::Client [![Build Status](https://travis-ci.org/jmaddi/liftapp-client.png)](https://travis-ci.org/jmaddi/liftapp-client)

Ruby library to access the Lift.do API. Since there is not yet an official API, this library uses the undocumented mobile app API.

For an example of what you can build, see http://lift-export.herokuapp.com/

## Installation

Add this line to your application's Gemfile:

    gem 'liftapp-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install liftapp-client

## Usage

##### Request your profile_hash
```ruby
# Log in with your email/password
client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
puts client.profile_hash
```

##### Request your subscribed habits
```ruby
client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
data = client.dashboard
data['subscriptions'].each do |subscription|
  puts subscription['habit']['name'] + ": " + subscription['habit']['id'].to_s
end

Nightly survey: 75655
Write: 3280
Test Lift: 2111
Keep in touch with friends: 2829
Organize social event: 71452
```

##### Request checkin data for your habit
```ruby
client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
data = client.checkin_data('3280')
puts data['checkins'].inspect
puts data['habit-name']
```

##### Checkin to a habit
```ruby
client = Liftapp::Client.new('neo@matrix.com', 'whiterabbit')
data = client.dashboard
puts data['subscriptions'][1]['habit']['name']
habit_id = data['subscriptions'][0]['habit']['id']
client.checkin(habit_id)
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
