require "spec_helper"

module Atethechon
  RSpec.describe WorldBankParser do
    describe "#parse" do
      it "parses world bank contact data" do
        parser = WorldBankParser.new

        result = parser.parse

        expect(result.size).to eq(126)
        expect(result.find { |contact| contact.location == "Cambodia" }).to have_attributes(
          location: "Cambodia",
          name: "Saroeun Bou",
          email: "sbou@worldbank.org",
          region: "East Asia and Pacific"
        )
      end
    end
  end
end
