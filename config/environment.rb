require 'rubygems'
require 'bundler'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require './calculator_api'
