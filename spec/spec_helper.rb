require 'support/fake_liftapi'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /www.lift.do/).to_rack(FakeLiftAPI)
  end
end
