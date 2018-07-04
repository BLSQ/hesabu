module Hesabu
  module Types
    StringLit = Struct.new(:string) do
      def eval
        string
      end
    end
  end
end
