# frozen_string_literal: true

require "veracode_api_signing/exception"
require "veracode_api_signing/regions"

module VeracodeApiSigning
  module Validation
    include Regions

    # @param api_key_id [String] the api key id to validate
    # @example
    #     validate_api_key_id("3ddaeeb10ca690df3fee5e3bd1c329fa") #=> nil
    # @example
    #     validate_api_key_id("3ddaeeb10ca690df3f") #=> VeracodeApiSigning::CredentialsError
    # @raise [VeracodeApiSigning::CredentialsError] if api key id is not valid
    def validate_api_key_id(api_key_id)
      api_key_id_minimum_length = 32
      api_key_id_maximum_length = 128 + 9
      api_key_id_hex = remove_prefix_from_api_credential(api_key_id)

      if api_key_id.length < api_key_id_minimum_length
        raise VeracodeApiSigning::CredentialsError,
              "API key #{api_key_id} is #{api_key_id.length} characters, which is not long enough. The API key should be at least #{api_key_id_minimum_length} characters"
      end
      if api_key_id.length > api_key_id_maximum_length
        raise VeracodeApiSigning::CredentialsError,
              "API key #{api_key_id} is #{api_key_id.length} characters, which is too long. The API key should not be more than #{api_key_id_maximum_length} characters"
      end
      unless valid_hex?(api_key_id_hex)
        raise VeracodeApiSigning::CredentialsError,
              "API key #{api_key_id} does not seem to be hexadecimal"
      end
    end

    # @param api_key_secret [String] the api key secret to validate
    # @example
    #     validate_api_key_secret("0123456789abcdef"*8) #=> nil
    # @example
    #     validate_api_key_secret("0123456789abcdef") #=> Veracode::ApiSigning::CredentialsError
    # @raise [VeracodeApiSigning::CredentialsError] if api secret key is not valid
    def validate_api_key_secret(api_key_secret)
      secret_key_minimum_length = 128
      secret_key_maximum_length = 1024 + 9
      api_key_secret_hex = remove_prefix_from_api_credential(api_key_secret)

      if api_key_secret.length < secret_key_minimum_length
        raise VeracodeApiSigning::CredentialsError,
              "API secret key #{api_key_secret} is #{api_key_secret.length} characters, which is not long enough. The API secret key should be at least #{secret_key_minimum_length} characters"
      end
      if api_key_secret.length > secret_key_maximum_length
        raise VeracodeApiSigning::CredentialsError,
              "API secret key #{api_key_secret} is #{api_key_secret.length} characters, which is too long. The API secret key should not be more than #{secret_key_maximum_length} characters"
      end
      unless valid_hex?(api_key_secret_hex)
        raise VeracodeApiSigning::CredentialsError,
              "API secret key #{api_key_secret} does not seem to be hexadecimal"
      end
    end

    # @param scheme [String] the scheme to validate
    # @example
    #     validate_scheme("https") #=> true
    # @example
    #     validate_scheme("httpss") #=> VeracodeApiSigning::Exception
    # @return [Boolean] true if valid scheme, otherwise raise error
    # @raise [VeracodeApiSigning::Exception] if scheme is not valid
    def validate_scheme(scheme)
      if scheme.casecmp("https").zero?
        true
      else
        raise VeracodeApiSigning::Exception, "Only HTTPS APIs are supported by Veracode."
      end
    end

    # @param hex_string [String] the hex string to validate
    # @example
    #     valid_hex?("af") #=> true
    # @example
    #     valid_hex?("zh") #=> false
    # @return [Boolean] true if valid hex, otherwise false
    # @raise [VeracodeApiSigning::CredentialsError] if api secret key is not valid
    def valid_hex?(hex_string)
      hex_string = hex_string.to_s
      hex = true
      hex_string.chars.each do |digit|
        hex = false unless /[0-9A-Fa-f]/.match?(digit)
      end
      hex
    end
  end
end
