require "spec_helper"

module Atethechon
  RSpec.describe ContactsSerializer do
    describe "#to_h" do
      it "serializes contact data as a hash" do
        contacts = [
          Contact.new(
            name: "Bob Chan",
            phone_number: "+855 71 5222 222",
            country: "Cambodia",
            email: "bobchan@example.com",
            region: "East Asia and Pacific",
            organization: "World Bank"
          )
        ]

        serializer = ContactsSerializer.new(contacts:, organization_identifier: :world_bank)

        expect(serializer.to_h).to eq(
          {
            "world_bank" => {
              "contacts" => [
                {
                  "name" => "Bob Chan",
                  "phone_number" => "+855 71 5222 222",
                  "country" => "Cambodia",
                  "email" => "bobchan@example.com",
                  "region" => "East Asia and Pacific",
                  "organization" => "World Bank"
                }
              ]
            }
          }
        )
      end
    end
  end
end
