# frozen_string_literal: true

require "veracode_api_signing/regions"

module VeracodeApiSigning
  module Formatters
    include Regions
    # @param api_key_id [String] the veracode api key
    # @param host [String] the url host
    # @param url [String] the url path
    # @param method [String] method to use [get, post, put, patch, delete]
    # @example
    #     format_signing_data("0123456789abcdef", "veracode.com", "/home", "GET") #=> "id=0123456789abcdef&host=veracode.com&url=/home&method=GET"
    # @example
    #     format_signing_data("0123456789abcdef", "VERACODE.com", "/home", "get") #=> "id=0123456789abcdef&host=veracode.com&url=/home&method=GET"
    # @return [String] the formatted signing data
    def format_signing_data(api_key_id, host, url, method)
      # Ensure some things are in the right case.
      # Note: that path (url) is allowed to be case-sensitive (because path is sent along verbatim)
      api_key_id = remove_prefix_from_api_credential(api_key_id).downcase
      host = host.downcase
      method = method.upcase

      "id=#{api_key_id}&host=#{host}&url=#{url}&method=#{method}"
    end

    # @param auth_scheme [String] the veracode auth scheme
    # @param api_key_id [String] the veracode api key
    # @param timestamp [String] the epoch timestamp
    # @param nonce [String] the random nonce
    # @param signature [String] the veracode signature
    # @example
    #     format_veracode_hmac_header(auth_scheme="VERACODE-HMAC-SHA-256", api_key_id="702a1650", timestamp="1445452792746", nonce="3b1974fbaa7c97cc", signature="b81c0315b8df360778083d1b408916f8") => "VERACODE-HMAC-SHA-256 id=702a1650,ts=1445452792746,nonce=3b1974fbaa7c97cc,sig=b81c0315b8df360778083d1b408916f8"
    # @return [String] the formatted hmac header
    def format_veracode_hmac_header(auth_scheme, api_key_id, timestamp, nonce, signature)
      # NOTE: This should _NOT_ manipulate case and so-on, that would likely break things.
      api_key_id = remove_prefix_from_api_credential(api_key_id)
      "#{auth_scheme} id=#{api_key_id},ts=#{timestamp},nonce=#{nonce},sig=#{signature}"
    end
  end
end
