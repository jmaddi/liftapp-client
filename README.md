# Liftapp::Client

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
client = Liftapp::Client.new(email: 'neo@matrix.com', password: 'whiterabbit')
data = client.login()
puts data['profile_hash']
```

##### Request your subscribed habits
```ruby
client = Liftapp::Client.new(email: 'neo@matrix.com', password: 'whiterabbit')
data = client.dashboard
puts data['subscriptions'].inspect
```

##### Request checkin data for your habit
```ruby
client = Liftapp::Client.new(profile_hash: 'e7fcd2db926273e895ef')
data = client.checkin_data('3280')
puts data[:checkins].inspect
puts data[:'habit-name']
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
