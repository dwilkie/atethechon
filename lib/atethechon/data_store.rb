module Atethechon
  class DataStore
    def load(_key, with:)
      with.new.load
    end
  end
end
