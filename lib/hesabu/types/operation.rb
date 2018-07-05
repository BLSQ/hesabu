module Hesabu
  module Types
    Operation = Struct.new(:left, :operator, :right) do
      def eval
        op = operator.str.strip

        leftval = left.respond_to?(:eval, false) ? left.eval : left
        rightval = right.respond_to?(:eval, false) ? right.eval : right
        # puts "Operation : #{leftval} #{op} #{rightval}"
        result = if op == "+"
                   leftval + rightval
                 elsif op == "-"
                   leftval - rightval
                 elsif op == "*"
                   leftval * rightval
                 elsif op == "/"
                   raise DivideByZeroError, "division by 0 : #{leftval}/0" if rightval == 0
                   leftval / rightval
                 elsif op == ">"
                   leftval > rightval
                 elsif op == "<"
                   leftval < rightval
                 elsif op == ">="
                   leftval >= rightval
                 elsif op == "<="
                   leftval <= rightval
                 elsif op == "=" || op == "=="
                   leftval == rightval
                 elsif op == "!="
                   leftval != rightval
                 elsif op == "AND"
                   leftval && rightval
                 else
                   raise "unsupported operand : #{operator} : #{left} #{operator} #{right}"
                 end
        # puts "#{leftval} #{op}  #{right.eval} => #{result}"
        result
      end
    end
  end
end
