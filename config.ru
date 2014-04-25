require 'rubygems'
require 'bundler'

Bundler.require(:default)

require "./zendesk_endpoint"
run ZendeskEndpoint
