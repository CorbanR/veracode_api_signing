# frozen_string_literal: true

require "veracode_api_signing/utils"

class UtilsTest
  include VeracodeApiSigning::Utils
end

RSpec.describe VeracodeApiSigning::Utils do
  subject { UtilsTest.new }

  describe ".get_current_timestamp" do
    it "returns epoch timestamp" do
      timestamp = subject.get_current_timestamp
      expect(Time.at(timestamp)).to be_a(Time)
    end
  end

  describe ".generate_nonce" do
    it "returns nonce" do
      nonce = subject.generate_nonce
      expect(nonce.length).to eq(32)
    end
  end

  describe ".get_host_from_url" do
    context "when valid host" do
      it "returns host" do
        host = subject.get_host_from_url("https://www.foomanchoo.com/api/v1")
        expect(host).to eq("www.foomanchoo.com")
      end
    end

    context "when invalid host" do
      it "returns nil" do
        host = subject.get_host_from_url("foomancho")
        expect(host).to be_nil
      end
    end
  end

  describe ".get_path_and_params_from_url" do
    context "with path" do
      context "without params" do
        it "returns path" do
          path = subject.get_path_and_params_from_url("https://www.foomanchoo.com/api/v1")
          expect(path).to eq("/api/v1")
        end
      end

      context "with params" do
        it "returns path + params" do
          path = subject.get_path_and_params_from_url("https://www.foomanchoo.com/api/v1?foo=bar")
          expect(path).to eq("/api/v1?foo=bar")
        end

        it "returns longer path + params" do
          path = subject.get_path_and_params_from_url("https://www.foomanchoo.com/api/v1?pagesize=2&page=90")
          expect(path).to eq("/api/v1?pagesize=2&page=90")
        end
      end
    end

    context "without path" do
      context "without params" do
        it "returns path + params" do
          path = subject.get_path_and_params_from_url("https://www.foomanchoo.com")
          expect(path).to eq("")
        end
      end
    end
  end

  describe ".get_scheme_from_url" do
    context "with scheme" do
      it "returns https scheme" do
        scheme = subject.get_scheme_from_url("https://www.foomanchoo.com")
        expect(scheme).to eq("https")
      end

      it "returns http scheme" do
        scheme = subject.get_scheme_from_url("http://www.foomanchoo.com")
        expect(scheme).to eq("http")
      end
    end

    context "without scheme" do
      it "returns empty string" do
        scheme = subject.get_scheme_from_url("www.foomanchoo.com")
        expect(scheme).to eq("")
      end
    end
  end
end
