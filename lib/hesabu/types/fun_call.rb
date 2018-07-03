module Hesabu
  module Types
    class IfFunction
      def call(args)
        raise "expected args #{name} : #{args}" unless args.size != 2
        condition_expression = args[0]
        condition = condition_expression.eval
        condition ? args[1].eval : args[2].eval
      end
    end

    class SumFunction
      def call(args)
        values = args.map(&:eval)
        values.reduce(0, :+)
      end
    end

    class ScoreTableFunction
      def call(args)
        values = args.map(&:eval)
        target = values.shift
        matching_rules = values.each_slice(3).find do |lower, greater, result|
          greater.nil? || result.nil? ? true : lower <= target && target < greater
        end
        matching_rules.last
      end
    end

    class AvgFunction
      def call(args)
        values = args.map(&:eval)
        values.inject(0.0) { |acc, elem| acc + elem } / values.size
      end
    end

    class SafeDivFunction
      def call(args)
        eval_denom = args[1].eval
        if eval_denom == 0
          0
        else
          eval_num = args[0].eval
          eval_num / eval_denom.to_f
        end
      end
    end

    class MinFunction
      def call(args)
        values = args.map(&:eval)
        values.min
      end
    end

    class MaxFunction
      def call(args)
        values = args.map(&:eval)
        values.max
      end
    end

    class RandbetweenFunction
      def call(args)
        values = args.map(&:eval)
        rand(values.first..values.last)
      end
    end

    FUNCTIONS = {
      "if"          => IfFunction.new,
      "sum"         => SumFunction.new,
      "avg"         => AvgFunction.new,
      "min"         => MinFunction.new,
      "max"         => MaxFunction.new,
      "safe_div"    => SafeDivFunction.new,
      "randbetween" => RandbetweenFunction.new,
      "score_table" => ScoreTableFunction.new
    }.freeze

    FunCall = Struct.new(:name, :args) do
      def eval
        function_name = name.strip.downcase
        function = FUNCTIONS[function_name]
        raise "unsupported function call  : #{function_name} only knows #{FUNCTIONS.keys.join(', ')}" unless function
        function.call(args)
      end
    end
  end
end
