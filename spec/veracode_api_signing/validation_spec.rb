# frozen_string_literal: true

require "veracode_api_signing/validation"

class ValidationTest
  include VeracodeApiSigning::Validation
end

RSpec.describe VeracodeApiSigning::Validation do
  subject { ValidationTest.new }

  describe ".validate_api_key_id" do
    context "when api key is valid" do
      it "returns nil" do
        expect(subject.validate_api_key_id("3ddaeeb10ca690df3fee5e3bd1c329fa")).to be_nil
      end
    end

    context "when api key to short" do
      it "raises not long enough error" do
        expect{subject.validate_api_key_id("3ddaeeb10ca69")}.to raise_error(VeracodeApiSigning::CredentialsError, /which is not long enough/)
      end
    end

    context "when api key is to long" do
      it "raises to long error" do
        expect{subject.validate_api_key_id("3ddaeeb10ca690df3fee5e3bd1c329fa3ddaeeb3ddaeeb"*8)}.to raise_error(VeracodeApiSigning::CredentialsError, /which is too long/)
      end
    end

    context "when api key is not hexadecimal" do
      it "returns key not hexidecimal error" do
        expect{subject.validate_api_key_id("zh345678910111213141516171819201")}.to raise_error(VeracodeApiSigning::CredentialsError, /does not seem to be hexadecimal/)
      end
    end
  end

  describe ".validate_api_key_secret" do
    context "when api key is valid" do
      it "returns nil" do
        expect(subject.validate_api_key_secret("0123456789abcdef"*8)).to be_nil
      end
    end

    context "when api key to short" do
      it "raises not long enough error" do
        expect{subject.validate_api_key_secret("0123456789abcdef")}.to raise_error(VeracodeApiSigning::CredentialsError, /which is not long enough/)
      end
    end

    context "when api key is to long" do
      it "raises to long error" do
        expect{subject.validate_api_key_secret("3ddaeeb10ca690df3fee5e3bd1c329fa3ddaeeb3ddaeeb"*8*8)}.to raise_error(VeracodeApiSigning::CredentialsError, /which is too long/)
      end
    end

    context "when api key is not hexadecimal" do
      it "returns key not hexidecimal error" do
        expect{subject.validate_api_key_id("zh345678910111213141516171819201")}.to raise_error(VeracodeApiSigning::CredentialsError, /does not seem to be hexadecimal/)
      end
    end
  end

  describe ".validate_scheme" do
    context "when scheme is valid" do
      it "returns true" do
        aggregate_failures do
          expect(subject.validate_scheme("HTTPS")).to be true
          expect(subject.validate_scheme("https")).to be true
        end
      end
    end

    context "when scheme is invalid" do
      it "raises exception" do
        aggregate_failures do
          expect{subject.validate_scheme("http")}.to raise_error(VeracodeApiSigning::Exception, /Only HTTPS APIs are supported by Veracode/)
          expect{subject.validate_scheme("FTP")}.to raise_error(VeracodeApiSigning::Exception, /Only HTTPS APIs are supported by Veracode/)
        end
      end
    end
  end
end
