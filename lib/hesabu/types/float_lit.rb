module Hesabu
  module Types
    FloatLit = Struct.new(:float) do
      def eval
        Hesabu::Types.as_numeric(float)
      end
    end
  end
end
