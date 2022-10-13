require "spec_helper"

module Atethechon
  RSpec.describe WorldBankParser do
    describe "#parse" do
      it "parses world bank contact data" do
        parser = WorldBankParser.new

        result = parser.parse

        expect(result.size).to eq(126)
        expect(result.find { |contact| contact.country == "Cambodia" }).to have_attributes(
          country: "Cambodia",
          name: "Saroeun Bou",
          email: "sbou@worldbank.org",
          region: "East Asia and Pacific",
          phone_number: "+855 23 861 315",
          organization: "World Bank"
        )
        expect(result.find { |contact| contact.country == "Vietnam" }.phone_number).to eq("+84 4 3934 6600")
      end
    end
  end
end
