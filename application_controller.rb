require 'bundler'
Bundler.require
require 'twilio-ruby' 
require 'giphy'
require 'open-uri'
require 'statsd-ruby'
require 'dogapi'


class ApplicationController < Sinatra::Base


    # account_sid ||= ENV["account_sid"]
    # auth_token ||= ENV["auth_token"]
    # twilio_number ||= ENV["twilio_number"]

    ENV["account_sid"]
    ENV["auth_token"]
    ENV["twilio_number"]
    ENV["api_key"]
    ENV["app_key"]
    $dyno_id ||= ENV["DYNO"]
    # ENV["DYNO"]

    dog = Dogapi::Client.new("dd855f1dee243106686bef188eb4de07", "efd90032cdb1516f32261ce2bf25e0866949b868")
    dog.emit_event(Dogapi::Event.new('App test', :msg_title => 'Level 2 App test'))

    statsd = Statsd.new('localhost', 8125)
    statsd.increment('page.views')
    # statsd.increment('page.views', tags: ['app:example-app', "dyno_id:#{$dyno_id}"])

    # binding.pry

    get '/' do
        erb :index
    end

    post '/' do
        @recipient = params[:recipient]
        @keyword = params[:keyword]
        @number = params[:number]
        @message = params[:message]
        @sender = params[:sender]
        @greeting = "Hey #{@recipient}!, #{@message} - Sent by #{@sender}"
        @gif = Giphy.random(tag=@keyword).image_original_url.to_s
        # binding.pry

        @client = Twilio::REST::Client.new account_sid, auth_token 
     
        @client.account.messages.create({
        :from => twilio_number, 
        :to => @number,
        :body => @greeting, 
        :media_url => @gif })
        
        erb :result
    end 

end
