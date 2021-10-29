# frozen_string_literal: true

require "veracode_api_signing/exception"

RSpec.describe VeracodeApiSigning do
  describe "::Exception" do
    it "raises exception" do
      expect {raise VeracodeApiSigning::Exception}.to raise_error(VeracodeApiSigning::Exception)
    end
  end

  describe "::CredentialsError" do
    it "raises credentials error" do
      expect {raise VeracodeApiSigning::CredentialsError}.to raise_error(VeracodeApiSigning::CredentialsError)
    end
  end

  describe "::UnsupportedAuthSchemeException" do
    it "raises unsupported auth scheme exception error" do
      expect {raise VeracodeApiSigning::UnsupportedAuthSchemeException}.to raise_error(VeracodeApiSigning::UnsupportedAuthSchemeException)
    end
  end
end
