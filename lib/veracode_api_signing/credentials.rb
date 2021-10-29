# frozen_string_literal: true

require "veracode_api_signing/exception"

module VeracodeApiSigning
  class Credentials
    PROFILE_DEFAULT = "default"

    ENV_API_KEY_NAME = "VERACODE_API_KEY_ID"
    ENV_API_SECRET_KEY_NAME = "VERACODE_API_KEY_SECRET"
    ENV_PROFILE = "VERACODE_API_PROFILE"

    FIX_INSTRUCTIONS = "Please consult the documentation to get your Veracode credentials set up."

    # Get credentials from supported sources. Precedence is 1) env vars, 2) file.
    def get_credentials(auth_file="#{Dir.home}/.veracode/credentials")
      credentials_from_environment = get_credentials_from_environment_variables
      return credentials_from_environment if credentials_from_environment.compact.length == 2

      credentials_from_filesystem = get_credentials_from_filesystem(auth_file)
      if credentials_from_filesystem.compact.length == 2
        return credentials_from_filesystem
      else
        raise VeracodeApiSigning::CredentialsError, "Unable to determine credentials. Set environment variables #{ENV_API_KEY_NAME}, and #{ENV_API_SECRET_KEY_NAME} or create credentials file #{Dir.home}/.veracode/credentials"
      end
    end

    private

    def get_credentials_from_environment_variables
      [ENV[ENV_API_KEY_NAME], ENV[ENV_API_SECRET_KEY_NAME]]
    end


    def get_credentials_from_filesystem(auth_file)
      raise VeracodeApiSigning::CredentialsError, "Could not read credentials file #{auth_file}" unless File.exist?(auth_file)

      credentials_section_name = get_credentials_profile
      raw_creds = File.read(auth_file)
      api_key_id = raw_creds.match(/(\[#{credentials_section_name}\].*\n)(.*#{ENV_API_KEY_NAME.downcase}.*=)(.*\S)/) {|g| g[3]}&.strip&.tr('"', '')
        api_secret_key = raw_creds.match(/(\[#{credentials_section_name}\].*\n)(.*\n#{ENV_API_SECRET_KEY_NAME.downcase}.*=)(.*\S)/) {|g| g[3]}&.strip&.tr('"', '')

        [api_key_id, api_secret_key]
    end

    def get_credentials_profile
      ENV.fetch(ENV_PROFILE, PROFILE_DEFAULT)
    end
  end
end
