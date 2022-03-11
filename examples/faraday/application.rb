# frozen_string_literal: true

require "bundler"
Bundler.setup

require "faraday"
require "faraday/request"
require "veracode_api_signing/plugins/faraday_middleware"

# Example faraday request
class Application
  def connection
    Faraday.new "https://api.veracode.com" do |conn|
      # You can pass in the key and secret here if you want, otherwise the library will look for environment variables, or credentials located in `~/.veracode/credentials`
      # conn.request :veracode_api_signing, key_id, key_secret_id
      conn.request :veracode_api_signing
      conn.adapter Faraday.default_adapter
      conn.response :json
    end
  end

  def list_users
    users = connection.get("/api/authn/v2/users")
    users.body
  end

  def list_apps
    apps = connection.get("https://analysiscenter.veracode.com/api/5.0/getapplist.do")

    apps.body
  end
end

ex = Application.new
# Hash output
puts ex.list_users.inspect
# XML output
puts ex.list_apps.inspect
