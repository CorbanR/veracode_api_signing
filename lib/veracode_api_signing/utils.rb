# frozen_string_literal: true

require "securerandom"
require "uri"

module VeracodeApiSigning
  module Utils

    # @return [Integer] current epoch time * 1000 rounded
    def get_current_timestamp
      Time.now.utc.to_i * 1000.round
    end

    # @return [String] nonce string
    def generate_nonce
      SecureRandom.hex(16)
    end

    # @param url [String] the url to parse
    # @example
    #     get_host_from_url("https://api.example.com/foo/bar") #=> "api.example.com"
    # @return [String] just returns the host
    def get_host_from_url(url)
      parsed_url(url).host
    end

    # @param url [String] the url to parse
    # @example
    #     get_path_and_params_from_url("https://api.example.com/foo/bar") #=> "/foo/bar"
    # @example
    #     get_path_and_params_from_url("https://api.example.com") #=> ""
    # @example
    #     get_path_and_params_from_url("https://api.example.com/apm/v1/assets?page=2") #=> "/apm/v1/assets?page=2"
    # @return [String] returns the the path and params formatted, or an empty String
    def get_path_and_params_from_url(url)
      uri = parsed_url(url)
      path = uri.path
      params = uri.query
      return "" if (path.nil? || path.empty?) && params.nil?

      built_url = URI::HTTPS.build(path: path, query: params)
      built_url.request_uri
    end

    # @param url [String] the url to parse
    # @example
    #     get_scheme_from_url("https://api.example.com/foo/bar") #=> "https"
    # @example
    #     get_scheme_from_url("api.example.com") #=> ""
    def get_scheme_from_url(url)
      parsed_url(url).scheme.to_s
    end

    private

    def parsed_url(url)
      URI(url)
    end
  end
end
