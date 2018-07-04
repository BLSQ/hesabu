module Hesabu

  LeftOp = Struct.new(:operation, :right) {
    def call(left)      
      Types::Operation.new(left,operation, self.right).eval
    end
  }

  Seq    = Struct.new(:sequence) {
    def eval
      sequence.reduce { |accum, operation| operation.call(accum) }
    end
  }

  class Interpreter < Parslet::Transform

    rule(plist: sequence(:arr)) { arr }
    rule(plist: "()") { [] }
    rule(fcall: { name: simple(:name), varlist: sequence(:seq) }) do
      byebug
      Hesabu::Types::FunCall.new(name, vars)
    end
    rule(identifier: simple(:id)) { id.to_s }
    rule(variable: simple(:variable)) do |d|
      d[:var_identifiers]&.add(d[:variable])
      Hesabu::Types::IdentifierLit.new(d[:variable], d[:doc])
    end

    rule(str: subtree(:str)) do
      Hesabu::Types::StringLit.new(str.map { |char| char.values.first.str }.join)
    end

    rule(integer: simple(:integer)) { Hesabu::Types::IntLit.new(integer) }
    rule(float: simple(:float)) { Hesabu::Types::FloatLit.new(float) }

    rule(op: simple(:op), right: simple(:right)) { LeftOp.new(op, right) }
    rule(sequence(:seq)) { Seq.new(seq) }
    rule(left: simple(:left)) { 
      left
    }
  end
end
