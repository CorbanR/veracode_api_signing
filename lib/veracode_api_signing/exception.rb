# frozen_string_literal: true

module VeracodeApiSigning
  # Generic error thrown when anything goes wrong
  class Exception < StandardError; end

  # Thrown if there is anything Veracode credentials, such as not found, improper format ... etc
  class CredentialsError < Exception; end

  # Thrown if there is anything Veracode credentials, such as not found, improper format ... etc
  class UnsupportedAuthSchemeException < CredentialsError; end
end
