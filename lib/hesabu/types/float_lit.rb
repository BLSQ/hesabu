module Hesabu
  module Types
    FloatLit = Struct.new(:float) do
      def eval
        Hesabu::Types.as_bigdecimal(float)
      end
    end
  end
end
