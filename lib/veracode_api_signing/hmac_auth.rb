# frozen_string_literal: true

require "openssl"
require "veracode_api_signing/exception"
require "veracode_api_signing/formatters"
require "veracode_api_signing/regions"
require "veracode_api_signing/utils"
require "veracode_api_signing/validation"

module VeracodeApiSigning
  class HMACAuth
    include Validation
    include Utils
    include Formatters
    include Regions

    DEFAULT_AUTH_SCHEME = "VERACODE-HMAC-SHA-256"

    # @param host [String] The host of the request("api.veracode.com")
    # @param path [String] The path of the request("/v1/results")
    # @param method [String] The method of the request("GET", "POST")
    # @param api_key_id [String] The user's API key
    # @param api_key_secret [String] The user's API secret key
    # @param auth_scheme [String] What authentication algorithm will be used to create the signature of the request
    # @return [String] The value of Veracode compliant HMAC header
    def generate_veracode_hmac_header(host, path, method, api_key_id, api_key_secret, auth_scheme = DEFAULT_AUTH_SCHEME)
      signing_data = format_signing_data(api_key_id, host, path, method)
      timestamp = get_current_timestamp
      nonce = generate_nonce
      signature = create_signature(auth_scheme, api_key_secret, signing_data, timestamp, nonce)
      format_veracode_hmac_header(auth_scheme, api_key_id, timestamp, nonce, signature)
    end

    private

    # @param auth_scheme [String] Used to describe what algorithm to use when creating the signature
    # @param api_key_secret [String] The user's API secret key
    # @param signing_data [String] The data to be signed (usually consists of host, path, request method and other data)
    # @param timestamp [String] A unix timestamp to millisecond precision
    # @param nonce [String] A random value to prevent replay attacks
    # @return [String] The signature according to algorithm specified
    # @raise [VeracodeApiSigning::UnsupportedAuthSchemeException] if auth scheme is not supported
    def create_signature(auth_scheme, api_key_secret, signing_data, timestamp, nonce)
      if auth_scheme == "VERACODE-HMAC-SHA-256"
        create_hmac_sha_256_signature(api_key_secret, signing_data, timestamp, nonce)
      else
        raise VeracodeApiSigning::UnsupportedAuthSchemeException, "Auth scheme #{auth_scheme} not supported"
      end
    end

    # @param api_key_secret [String] The user's API secret key
    # @param signing_data [String] The data to be signed (usually consists of host, path, request method and other data)
    # @param timestamp [String] A unix timestamp to millisecond precision
    # @param nonce [String] A random value to prevent replay attacks
    # @return [String] An HMAC-SHA-256 signature
    def create_hmac_sha_256_signature(api_key_secret, signing_data, timestamp, nonce)
      api_key_secret = remove_prefix_from_api_credential(api_key_secret)
      key_nonce = generate_digest(hex_to_bin(api_key_secret), hex_to_bin(nonce))
      key_date = generate_digest(key_nonce, timestamp.to_s.encode)
      signature_key = generate_digest(key_date, "vcode_request_version_1".encode)

      OpenSSL::HMAC.hexdigest("sha256", signature_key, signing_data.encode)
    end

    # @param hex_string [String] the hex string
    # @return [String] The hex string converted to binary
    # @raise [VeracodeApiSigning::Exception] if string is NOT valid hex
    def hex_to_bin(hex_string)
      raise VeracodeApiSigning::Exception, "String is not valid hex: #{hex_string}" unless valid_hex?(hex_string)

      hex_string.scan(/../).map { |x| x.hex.chr }.join
    end

    def generate_digest(key, data)
      OpenSSL::HMAC.digest("sha256", key, data)
    end
  end
end
