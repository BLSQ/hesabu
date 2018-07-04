module Hesabu

  class Interpreter < Parslet::Transform

    rule(plist: sequence(:arr)) { arr }
    rule(plist: "()") { [] }
    rule( l:  simple(:left),
          r: simple(:right),
          o:    simple(:op)) do
      Hesabu::Types::Operation.new(left, op, right)
      end
    rule(identifier: simple(:id)) { id.to_s }
    rule(variable: simple(:variable)) do |d|
      d[:var_identifiers]&.add(d[:variable])
      Hesabu::Types::IdentifierLit.new(d[:variable], d[:doc])
    end
    rule(fcall: { name: simple(:name), varlist: sequence(:vars) }) do
      Hesabu::Types::FunCall.new(name, vars)
    end
    rule(str: subtree(:str)) do
      Hesabu::Types::StringLit.new(str.map { |char| char.values.first.str }.join)
    end

    rule(integer: simple(:integer)) { Hesabu::Types::IntLit.new(integer) }
    rule(float: simple(:float)) { Hesabu::Types::FloatLit.new(float) }

    
    rule(left: simple(:left)) { 
      left
    }
  end
end
