# frozen_string_literal: true

require "veracode_api_signing/hmac_auth"

RSpec.describe VeracodeApiSigning::HMACAuth do
  describe ".generate_veracode_hmac_header" do
    let(:api_key_id) { "3ddaeeb10ca690df3fee5e3bd1c329fa" }
    let(:api_key_secret) { "0123456789abcdef" * 8 }
    let(:host) { "api.veracode.com" }
    let(:path) { "/v1/results" }
    let(:method) { "GET" }

    context "when params valid" do
      it "returns signature" do
        header = described_class.new.generate_veracode_hmac_header(host, path, method, api_key_id, api_key_secret)
        expect(header).to include("VERACODE-HMAC-SHA-256", "id=", "nonce=", "sig=")
      end
    end

    context "when params invalid" do
      it "raises error" do
        expect do
          described_class.new.generate_veracode_hmac_header(host, path, method, api_key_id, api_key_secret,
                                                            "BAD-HMAC-SCHEME")
        end.to raise_error(VeracodeApiSigning::UnsupportedAuthSchemeException)
      end
    end
  end

  describe ".hex_to_bin" do
    context "when valid hex" do
      it "returns binary data" do
        binary = described_class.new.send(:hex_to_bin, "abc123")
        expect(binary.encoding.name).to eq("ASCII-8BIT")
      end
    end

    context "when invalid hex" do
      it "raises error" do
        expect do
          described_class.new.send(:hex_to_bin, "zh")
        end.to raise_error(VeracodeApiSigning::Exception, /String is not valid hex/)
      end
    end
  end
end
