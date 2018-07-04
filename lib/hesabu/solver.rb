module Hesabu
  class Solver
    include TSort

    Equation = Struct.new(:name, :evaluable, :dependencies)
    EMPTY_DEPENDENCIES = [].freeze
    FakeEvaluable = Struct.new(:eval)

    def initialize
      @parser = ::Hesabu::Parser.new
      @interpreter = ::Hesabu::Interpreter.new
      @equations = {}
      @bindings = {}
    end

    alias solving_order tsort

    def add(name, raw_expression)
      expression = raw_expression
      numeric = ::Hesabu::Types.as_numeric(raw_expression)

      if numeric
        @equations[name] = Equation.new(
          name,
          FakeEvaluable.new(::Hesabu::Types.as_bigdecimal(raw_expression)),
          EMPTY_DEPENDENCIES
        )
      else
        expression = raw_expression.gsub(/\r\n?/, "")
        ast_tree = begin
          @parser.parse(expression)
        rescue Parslet::ParseFailed => e
          raise "failed to parse #{name} := #{expression} : #{e.message}"
        end
        var_identifiers = Set.new
        interpretation = @interpreter.apply(
          ast_tree,
          doc:             @bindings,
          var_identifiers: var_identifiers
        )
        @equations[name] = Equation.new(name, interpretation, var_identifiers)
      end
    end

    def solve!
      solving_order.each do |name|
        equation = @equations[name]
        raise "not evaluable #{equation.evaluable} #{equation}" unless equation.evaluable.respond_to?(:eval, false)
        @bindings[equation.name] = equation.evaluable.eval
      end
      solution = @bindings.dup
      @bindings.clear
      solution.each_with_object({}) do |kv, hash|
        hash[kv.first] = Hesabu::Types.as_numeric(kv.last) ||kv.last
      end
    end

    def tsort_each_node(&block)
      @equations.each_key(&block)
    end

    def tsort_each_child(node, &block)
      @equations[node].dependencies.each(&block)
    end
  end
end
