module Hesabu
  module Types
    Operation = Struct.new(:left, :operator, :right) do
      def eval
        op = operator.str.strip

        result = if op == "+"
                   left.eval + right.eval
                 elsif op == "-"
                   left.eval - right.eval
                 elsif op == "*"
                   left.eval * right.eval
                 elsif op == "/"
                   left.eval / right.eval.to_f
                 elsif op == ">"
                   left.eval > right.eval
                 elsif op == "<"
                   left.eval < right.eval
                 elsif op == ">="
                   left.eval >= right.eval
                 elsif op == "<="
                   left.eval <= right.eval
                 elsif op == "=" || op == "=="
                   left.eval == right.eval
                 else
                   raise "unsupported operand : #{operator} : #{left} #{operator} #{right}"
                 end
        # puts "#{left.eval} #{op}  #{right.eval} => #{result}"
        result
      end
    end
  end
end
