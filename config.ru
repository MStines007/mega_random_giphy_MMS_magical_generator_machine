require 'sinatra/base'
require 'dotenv'
Dotenv.load
require './application_controller'
run ApplicationController

