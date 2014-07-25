require 'httparty'
require 'nokogiri'
# require 'json'
# require 'date'

require "liftapp-client/version"

module Liftapp

  class AccessDenied < StandardError; end

  class Client
    attr_reader :profile_hash
    attr_reader :name
    attr_reader :picture_url
    attr_reader :email
    attr_reader :profile_id

    def initialize(email, password)
      @user_agent = 'Lift/0.27.1779 CFNetwork/609.1.4 Darwin/13.0.0'

      @auth_options = {basic_auth: {username: email, password: password}}
      
      @options = {}
      @options.merge!(@auth_options)
      @options.merge!({headers: {'User-Agent' => @user_agent}})

      response = HTTParty.get('https://www.lift.do/i/0/users/current', @options)

      raise AccessDenied, 'Invalid email/password' if response.response.code == '401'

      @email        = response['email']
      @profile_hash = response['profile_hash']
      @picture_url  = response['picture_url']
      @name         = response['name']
      @profile_id   = response['id']
    end

    # Working
    def dashboard
      HTTParty.get('https://www.lift.do/api/v3/dashboard', @options)
    end
    
    def view_habits
      # puts or maps to hash?
    end
    
    # Working, shows all recent checkins from all following
    def habit_activity(habit_id)
      HTTParty.get('https://www.lift.do/api/v2/habits/%d/activity' % habit_id, @options)
    end
    
    # NOT WORKING Changed from v1 to v3 and it checked me into weird habit (Warm Water & Lemon)
    def checkin(habit_id, time=DateTime.now)
      data = {body: {habit_id: habit_id, date: time.to_s}}
      HTTParty.post('https://www.lift.do/api/v3/checkins', @options.merge(data))
    end

    # NOT WORKING
    def checkout(checkin_id)
      HTTParty.delete('https://www.lift.do/api/v3/checkins/%d' % checkin_id)
    end
  
    # NOT WORKING (page has changed format)
    def checkin_data(habit_id)
      response = HTTParty.get('https://www.lift.do/users/%s/%d' % [@profile_hash, habit_id])

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
        'habit-name' => doc.search('.profile-habit-name').first.content,
        'checkins'     => checkins.sort
      }
    end
  end

end
