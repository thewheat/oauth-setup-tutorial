#!/usr/bin/env ruby
#
# This code snippet shows how to enable SSL in Sinatra+Thin.
#

require 'sinatra'
require 'thin'
require 'json'
require 'slim'
require 'json'
require "net/http"
require "uri"
require 'intercom'

class MyThinBackend < ::Thin::Backends::TcpServer
  def initialize(host, port, options)
    super(host, port)
    @ssl = true
    @ssl_options = options
  end
end

configure do
  set :environment, :production
  set :bind, '0.0.0.0'
  #:set :port, 443
  set :server, "thin"
  enable :sessions
end

get '/' do
  File.read('intercom.html')
end

get '/home' do
  "Welcome Back"
end

get '/callback' do
  #Get the Code passed back to our redirect callback
  session[:code] = params[:code]
  session[:state] = params[:state]

  puts "CODE: #{session[:code]}"
  puts "STATE:#{session[:state]}"

  #We can do a Post now to get the access token
  uri = URI.parse("https://api.intercom.io/auth/eagle/token")
  response = Net::HTTP.post_form(uri, {"code" => params[:code],
                                       "client_id" => "<CLIENT_ID>",
                                       "client_secret" => "<CLIENT_SECRET>"})

  #Break Up the response and print out the Access Token
  rsp = JSON.parse(response.body)
  session[:token] = rsp["token"]

  puts "ACCESS TOKEN: #{session[:token]}"
  intercom = Intercom::Client.new(token: session[:token])
  admin = intercom.admins.me
  puts admin.inspect
  puts "============="
  puts "Admin details"
  puts "============="
  puts "id: #{admin.id}"
  puts "name: #{admin.name}"
  puts "email: #{admin.email}"
  puts "email_verified: #{admin.email_verified}"
  puts "has_inbox_seat: #{admin.has_inbox_seat}"
  puts "==========="
  puts "App Details"
  puts "==========="
  puts "id_code: #{admin.app.id_code}"
  puts "name: #{admin.app.name}"
  puts "created_at: #{admin.app.created_at}"
  puts "secure: #{admin.app.secure}"
  puts "identity_verification: #{admin.app.identity_verification}"
  puts "timezone: #{admin.app.timezone}"
  redirect '/home'
end
