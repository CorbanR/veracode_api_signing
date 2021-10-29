# frozen_string_literal: true

require "veracode_api_signing/credentials"

RSpec.describe VeracodeApiSigning::Credentials do
  describe ".get_credentials" do
    let(:test_credentials) do
      {
        "VERACODE_API_KEY_ID" => "3ddaeeb10ca690df3fee5e3bd1c329fa",
        "VERACODE_API_KEY_SECRET" => "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
      }
    end

    let(:test_credentials_file) do
      <<-EOF
[default]
veracode_api_key_id = 3ddaeeb10ca690df3fee5e3bd1c329fa
veracode_api_key_secret = 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
      EOF
    end

    let(:test_credentials_file_multiple) do
      <<-EOF
[default]
veracode_api_key_id = abc123
veracode_api_key_secret = 01234
[test]
veracode_api_key_id = 3ddaeeb10ca690df3fee5e3bd1c329fa
veracode_api_key_secret = 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
      EOF
    end

    context "when credential environment variables are set" do
      it "fetches credentials from the environment" do

        stub_env(test_credentials)
        api_key_id, api_key_secret = described_class.new.get_credentials
        credentials =
          {
            "VERACODE_API_KEY_ID" => api_key_id,
            "VERACODE_API_KEY_SECRET" => api_key_secret
          }

        expect(credentials).to eq(test_credentials)
      end
    end

    context "when credential environment variables are not set" do
      context "when credentials file has one profile" do
        it "fetches credentials from file" do
          allow(File).to receive(:exist?).with(anything).and_return(true)
          allow(File).to receive(:read).with(anything).and_return(test_credentials_file)

          api_key_id, api_key_secret = described_class.new.get_credentials
          credentials =
            {
              "VERACODE_API_KEY_ID" => api_key_id,
              "VERACODE_API_KEY_SECRET" => api_key_secret
            }

          expect(credentials).to eq(test_credentials)
        end
      end

      context "when credentials file has multiple profiles" do
        it "fetches correct profile from credentials file" do
          allow(File).to receive(:exist?).with(anything).and_return(true)
          allow(File).to receive(:read).with(anything).and_return(test_credentials_file_multiple)
          stub_env({"VERACODE_API_PROFILE" => "test"})

          api_key_id, api_key_secret = described_class.new.get_credentials
          credentials =
            {
              "VERACODE_API_KEY_ID" => api_key_id,
              "VERACODE_API_KEY_SECRET" => api_key_secret
            }

          expect(credentials).to eq(test_credentials)
        end
      end

      context "when credentials file does not exist" do
        it "raises 'could not read' error" do
          allow(File).to receive(:exist?).with(anything).and_return(false)
          expect { described_class.new.get_credentials }.to raise_error(VeracodeApiSigning::CredentialsError, /Could not read/)
        end
      end

      context "when credentials file does not contain secret" do
        let(:test_credentials_file_invalid) do
          <<-EOF
[default]
veracode_api_key_id = abc123
          EOF
        end

        it "raises 'Unable to determine credentials' error" do
          allow(File).to receive(:exist?).with(anything).and_return(true)
          allow(File).to receive(:read).with(anything).and_return(test_credentials_file_invalid)
          expect { described_class.new.get_credentials }.to raise_error(VeracodeApiSigning::CredentialsError, /Unable to determine credentials/)
        end
      end
    end
  end
end
