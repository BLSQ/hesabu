module Hesabu
  module Types
    IdentifierLit = Struct.new(:var_identifier, :bindings) do
      def eval
        bindings[var_identifier] ||= 0
      end
    end
  end
end
