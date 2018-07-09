
module Hesabu
  class Error < StandardError
    attr_accessor :errors
    def iniatialize(message)
      super(message)
      @errors = errors
    end
  end
  class ArgumentError < Error
    def iniatialize(message)
      super(message)
    end
  end
end
