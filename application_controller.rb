require 'bundler'
Bundler.require
require 'twilio-ruby' 
require 'giphy'
require 'open-uri'


class ApplicationController < Sinatra::Base

    account_sid ||= ENV["account_sid"]
    auth_token ||= ENV["auth_token"]
    twilio_number ||= ENV["twilio_number"]

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
