require "delegate"

module Atethechon
  class StoreCache < SimpleDelegator
    attr_reader :cached

    def initialize(data_store)
      super(data_store)

      @cached = {}
    end

    def load(key, ...)
      cached.fetch(key) do
        cached[key] = super
      end
    end
  end
end
