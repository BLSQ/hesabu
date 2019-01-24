module Hesabu
  class Error < StandardError
    attr_accessor :errors
  end
  class ArgumentError < Error
  end
  class UnsupportedPlatform < StandardError
  end
end
