module Atethechon
  class ContactsSerializer
    attr_reader :contacts, :organization_identifier

    def initialize(contacts:, organization_identifier:)
      @contacts = contacts
      @organization_identifier = organization_identifier
    end

    def to_yaml
      to_h.to_yaml
    end

    def to_h
      {
        organization_identifier.to_s => {
          "contacts" => contacts.map { |c| c.to_h.transform_keys(&:to_s) }
        }
      }
    end
  end
end
