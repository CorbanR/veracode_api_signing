# frozen_string_literal: true

require "veracode_api_signing/regions"

class RegionsTest
  include VeracodeApiSigning::Regions
end

RSpec.describe VeracodeApiSigning::Regions do
  subject { RegionsTest.new }

  describe ".get_region_for_api_credential" do
    context "when credentials prefix is valid" do
      context "when region is global" do
        it "returns the correct region" do
          region = subject.get_region_for_api_credential("3ddaegb10ca690df3fee5e3bd1c329fa")
          expect(region).to eq("global")
        end
      end

      context "when region is fedramp" do
        it "returns the correct region" do
          region = subject.get_region_for_api_credential("vera01fs-3ddaefb10ca690df3fee5e3bd1c329fa")
          expect(region).to eq("fedramp")
        end
      end

      context "when region is eu" do
        it "returns the correct region" do
          region = subject.get_region_for_api_credential("vera01es-3ddaefb10ca690df3fee5e3bd1c329fa")
          expect(region).to eq("eu")
        end
      end
    end

    context "when credentials prefix is invalid" do
      it "raises credentials error" do
        expect do
          subject.get_region_for_api_credential("ver-3ddaefb10ca690df3fee5e3bd1c329fa")
        end.to raise_error(VeracodeApiSigning::CredentialsError, /Credential starts with an invalid prefix/)
      end
    end
  end

  describe ".remove_prefix_from_api_credential" do
    it "removes prefix from credential" do
      credential = subject.remove_prefix_from_api_credential("vera01es-3ddaefb10ca690df3fee5e3bd1c329fa")
      expect(credential).to eq("3ddaefb10ca690df3fee5e3bd1c329fa")
    end
  end
end
