
module Hesabu
  class Error < StandardError
  end
  class ArgumentError < Error
  end
  class ParseError < Error
  end
  class CalculationError < Error
  end
  class DivideByZeroError < Error
  end
  class CyclicError < Error
  end
  class UnboundVariableError < Error
  end
end
