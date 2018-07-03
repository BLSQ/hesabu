module Hesabu
  module Types
    IntLit = Struct.new(:int) do
      def eval
        int.to_i
      end
    end
  end
end
