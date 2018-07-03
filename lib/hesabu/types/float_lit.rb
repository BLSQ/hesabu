module Hesabu
  module Types
    FloatLit = Struct.new(:float) do
      def eval
        float.to_f
      end
    end
  end
end
