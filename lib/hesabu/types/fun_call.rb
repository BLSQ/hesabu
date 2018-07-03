module Hesabu
  module Types
    FunCall = Struct.new(:name, :args) do
      def eval
        function_name = name.strip.downcase
        if function_name == "if"
          raise "expected args #{name} : #{args}" unless args.size != 2
          condition_expression = args[0]
          condition = condition_expression.eval
          condition ? args[1].eval : args[2].eval
        elsif function_name == "sum"
          values = args.map(&:eval)
          values.reduce(0, :+)
        elsif function_name == "safe_div"
          eval_denom = args[1].eval
          if eval_denom == 0
            0
          else
            eval_num = args[0].eval
            eval_num / eval_denom.to_f
          end
        elsif function_name == "min"
          values = args.map(&:eval)
          values.min
        elsif function_name == "max"
          values = args.map(&:eval)
          values.max
        elsif function_name == "avg"
          values = args.map(&:eval)
          values.inject(0.0) { |acc, elem| acc + elem } / values.size
        elsif function_name == "score_table"
          values = args.map(&:eval)
          target = values.shift
          matching_rules = values.each_slice(3).find do |lower, greater, result|
            greater.nil? || result.nil? ? true : lower <= target && target < greater
          end
          matching_rules.last
        elsif function_name == "randbetween"
          values = args.map(&:eval)
          rand(values.first..values.last)
        else
          raise "unsupported function call  : #{function_name}"
        end
      end
    end
  end
end
