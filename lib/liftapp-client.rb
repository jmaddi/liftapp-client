require 'httparty'
require 'json'
require 'nokogiri'

require "liftapp-client/version"

module Liftapp
  class Client
    attr_accessor :profile_hash

    def initialize(args)
      @email     = args[:email] if args[:email]
      @password     = args[:password] if args[:password]
      @profile_hash = args[:profile_hash] if args[:profile_hash]
      if (@email && @password)
        @auth_options = {basic_auth: {username: @email, password: @password}}
      end
    end

    def login
      response = HTTParty.get('https://www.lift.do/i/0/users/current', @auth_options)
      @profile_hash = response['profile_hash']
      response
    end

    def dashboard
      HTTParty.get('https://www.lift.do/api/v2/dashboard', @auth_options)
    end

    def habit_activity(habit_id)
      HTTParty.get('https://www.lift.do/api/v2/habits/' + habit_id + '/activity', @auth_options)
    end

    def checkin_data(habit_id)
      response = HTTParty.get('https://www.lift.do/users/' + @profile_hash + '/' + habit_id)

      doc = Nokogiri::HTML(response.body)

      month_names  = doc.search('//*[@id="profile-calendar"]/div/div/h3')
      month_tables = doc.search('#profile-calendar table')
      checkins = []

      while (!month_names.empty?)
        month_name  = month_names.shift
        month_table = month_tables.shift
        month_table.search('div.checked').each do |day|
          m_day = day.text
          checkins.push(Date.parse(m_day + ' ' + month_name.content))
        end
      end
      {
        :'habit-name' => doc.search('.profile-habit-name').first.content,
        :checkins     => checkins.sort
      }
    end

    def to_s
      "Liftapp (#@email)"
    end

  end
end
