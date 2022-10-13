module Atethechon
  Contact = Struct.new(:name, :email, :country, :phone_number, :region, :organization, keyword_init: true) do
    class << self
      attr_accessor :data_store_key

      def all
        data
      end

      private

      def data
        Atethechon.data_store.load(:contacts, with: ContactParser)
      end
    end
  end
end
