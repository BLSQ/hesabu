module Hesabu
  module Types
    Operation = Struct.new(:left, :operator, :right) do
      def eval
        op = operator.str.strip
        result(op, left.eval, right.eval)
      end

      private

      def result(op, leftval, rightval)
        case op
        when "+"
          leftval + rightval
        when  "-"
          leftval - rightval
        when  "*"
          leftval * rightval
        when  "/"
          raise DivideByZeroError, "division by 0 : #{leftval}/0" if rightval == 0
          leftval / rightval
        when  ">"
          leftval > rightval
        when  "<"
          leftval < rightval
        when  ">="
          leftval >= rightval
        when  "<="
          leftval <= rightval
        when  "=", "=="
          leftval == rightval
        when  "!="
          leftval != rightval
        when  "AND"
          leftval && rightval
        else
          raise "unsupported operand : #{op} : #{left} #{operator} #{right}"
        end
      end
    end
  end
end
