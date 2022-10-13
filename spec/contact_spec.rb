require "spec_helper"

module Atethechon
  RSpec.describe Contact do
    describe ".all" do
      it "returns all contacts" do
        result = Contact.all

        expect(result.first).to have_attributes(
          name: "Svetlana Markova"
        )
      end
    end
  end
end
