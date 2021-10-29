# frozen_string_literal: true

require "veracode_api_signing/exception"

module VeracodeApiSigning
  module Regions
    REGIONS = { "e" => "eu", "f" => "fedramp", "g" => "global" }.freeze

    def get_region_for_api_credential(api_credential)
      if api_credential.include?("-")
        prefix = api_credential.split("-").first
        raise VeracodeApiSigning::CredentialsError, "Credential starts with an invalid prefix" if prefix.length != 8

        region_character = prefix[6].downcase
      else
        region_character = "g"
      end

      if REGIONS.key?(region_character)
        REGIONS.fetch(region_character)
      else
        (raise VeracodeApiSigning::CredentialsError,
               "Credential does not map to a known region")
      end
    end

    def remove_prefix_from_api_credential(api_credential)
      api_credential.split("-").last
    end
  end
end
