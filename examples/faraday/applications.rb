# frozen_string_literal: true

require 'bundler'
Bundler.setup

require "faraday"
require "faraday/request"
require "veracode_api_signing/plugins/faraday_middleware"


connection = Faraday.new 'https://api.veracode.com/' do |conn|
  # You can pass in the key and secret here if you want, otherwise the library will look for environment variables, or credentials located in `~/.veracode/credentials`
  # conn.request :veracode_api_signing, key_id, key_secret_id
  conn.request :veracode_api_signing
  conn.adapter Faraday.default_adapter
end

applications = connection.get("/api/authn/v2/users")
puts applications.inspect
