# frozen_string_literal: true

require "bundler"
Bundler.setup

require "json"
require "net/http"
require "veracode_api_signing"
require "veracode_api_signing/credentials"

url = "https://api.veracode.com/api/authn/v2/users"
veracode = VeracodeApiSigning::HMACAuth.new

# VeracodeApiSigning::HMACAuth.new includes some helper methods from VeracodeApiSigning::Utils
# parsed_url is just a wrapper around URI()
uri = veracode.parsed_url(url)
req = Net::HTTP::Get.new(uri)

# Try to get creds from environment variables or ~/.veracode/credentials
api_key_id, api_secret_key = VeracodeApiSigning::Credentials.new.get_credentials

# Create HMAC signature
auth = VeracodeApiSigning::HMACAuth.new.generate_veracode_hmac_header(
  veracode.get_host_from_url(url),
  veracode.get_path_and_params_from_url(url),
  "GET", api_key_id,
  api_secret_key
)

# Add Authorization heaader
req["Authorization"] = auth

res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  http.request(req)
end

raise "ERROR: response code #{res.code}" unless res.code == "200"

res = JSON.parse(res.body)
puts res
