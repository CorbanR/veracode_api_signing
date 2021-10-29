# frozen_string_literal: true

require "faraday"
require "faraday/request"
require "veracode_api_signing/credentials"
require "veracode_api_signing/utils"
require "veracode_api_signing/hmac_auth"
require "veracode_api_signing/validation"

module VeracodeApiSigning
  module Plugins
    class FaradayMiddleware < Faraday::Middleware
      include Validation, Utils

      KEY = "Authorization"

      attr_reader :api_key_id, :api_secret_key

      # @param app [#call]
      # @param api_key_id [String] the veracode api key
      # @param api_secret_key [String] The user's API secret key
      def initialize(app, api_key_id=nil, api_secret_key=nil)
        if api_key_id && api_secret_key
          validate_credentials(api_key_id, api_secret_key)
          @api_key_id = api_key_id
          @api_secret_key = api_secret_key
        else
          api_key_id, api_secret_key = Credentials.new.get_credentials
          validate_credentials(api_key_id, api_secret_key)
          @api_key_id = api_key_id
          @api_secret_key = api_secret_key
        end

        super(app)
      end

      # @param env [Faraday::Env]
      def on_request(env)
        return if env.request_headers[KEY]
        url = env.url
        host = get_host_from_url(url)
        path = get_path_and_params_from_url(url)
        method = env.method.to_s.upcase
        auth = HMACAuth.new.generate_veracode_hmac_header(host, path, method, api_key_id, api_secret_key)
        #env.request_headers["Content-Type"] = "application/json"
        #env.request_headers["Accept-Encoding"] = "gzip, deflate, br"
        #env.request_headers["Accept"] = "*/*"
        #env.request_headers["Connection"] = "keep-alive"
        env.request_headers[KEY] = auth
      end

      def validate_credentials(key, secret)
        validate_api_key_id(key)
        validate_api_key_secret(secret)
      end
    end
  end
end
Faraday::Request.register_middleware(veracode_api_signing: VeracodeApiSigning::Plugins::FaradayMiddleware)
