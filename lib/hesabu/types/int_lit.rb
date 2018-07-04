module Hesabu
  module Types
    IntLit = Struct.new(:int) do
      def eval
        ::Hesabu::Types.as_bigdecimal(int)
      end
    end
  end
end
