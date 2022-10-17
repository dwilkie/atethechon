require_relative "atethechon/data_store"
require_relative "atethechon/store_cache"
require_relative "atethechon/contact"
require_relative "atethechon/contact_parser"
require_relative "atethechon/scrapers"
require_relative "atethechon/serializers"

module Atethechon
  class << self
    def data_store
      @data_store ||= reset_data_store!
    end

    private

    def reset_data_store!
      @data_store = StoreCache.new(DataStore.new)
    end
  end
end
