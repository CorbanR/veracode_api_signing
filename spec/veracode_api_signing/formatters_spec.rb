# frozen_string_literal: true

require "veracode_api_signing/formatters"

class FormattersTest
  include VeracodeApiSigning::Formatters
end

RSpec.describe VeracodeApiSigning::Formatters do
  subject { FormattersTest.new }

  describe ".format_signing_data" do
    context "when host is downcase is" do
      it "correctly formats data" do
        formatted_data = subject.format_signing_data("0123456789abcdef", "veracode.com", "/home", "GET")
        expect(formatted_data).to eq("id=0123456789abcdef&host=veracode.com&url=/home&method=GET")
      end
    end

    context "when host is uppercase" do
      it "correctly formats data" do
        formatted_data = subject.format_signing_data("0123456789abcdef", "VERACODE.com", "/home", "GET")
        expect(formatted_data).to eq("id=0123456789abcdef&host=veracode.com&url=/home&method=GET")
      end
    end

    context "when key is uppercase" do
      it "correctly formats data" do
        formatted_data = subject.format_signing_data("0123456789ABCDEF", "VERACODE.com", "/home", "GET")
        expect(formatted_data).to eq("id=0123456789abcdef&host=veracode.com&url=/home&method=GET")
      end
    end
  end

  describe ".format_veracode_hmac_header" do
    context "when downcase" do
      it "data is formatted as downcase" do
        formatted_data = subject.format_veracode_hmac_header(
          auth_scheme="VERACODE-HMAC-SHA-256",
          api_key_id="702a1650",
          timestamp="1445452792746",
          nonce="3b1974fbaa7c97cc",
          signature="b81c0315b8df360778083d1b408916f8"
        )
        expect(formatted_data).to eq("VERACODE-HMAC-SHA-256 id=702a1650,ts=1445452792746,nonce=3b1974fbaa7c97cc,sig=b81c0315b8df360778083d1b408916f8")
      end
    end

    context "when uppercase" do
      it "data is formatted as uppercase" do
        formatted_data = subject.format_veracode_hmac_header(
          auth_scheme="VERACODE-HMAC-SHA-256",
          api_key_id="702A1650",
          timestamp="1445452792746",
          nonce="3B1974FBAA7C97CC",
          signature="B81C0315B8DF360778083D1B408916F8"
        )
        expect(formatted_data).to eq("VERACODE-HMAC-SHA-256 id=702A1650,ts=1445452792746,nonce=3B1974FBAA7C97CC,sig=B81C0315B8DF360778083D1B408916F8")
      end
    end
  end
end
