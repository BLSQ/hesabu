module Hesabu
  class Solver
    include TSort

    Equation = Struct.new(:name, :evaluable, :dependencies, :raw_expression)
    EMPTY_DEPENDENCIES = [].freeze
    FakeEvaluable = Struct.new(:eval)

    def initialize
      @parser = ::Hesabu::Parser.new
      @interpreter = ::Hesabu::Interpreter.new
      @equations = {}
      @bindings = {}
    end

    def add(name, raw_expression)
      if ::Hesabu::Types.as_numeric(raw_expression)
        add_numeric(name, raw_expression)
      else
        add_equation(name, raw_expression)
      end
    end

    def solve!
      solving_order.each do |name|
        equation = @equations[name]
        raise "not evaluable #{equation.evaluable} #{equation}" unless equation.evaluable.respond_to?(:eval, false)
        begin
          @bindings[equation.name] = equation.evaluable.eval
        rescue StandardError => e
          raise CalculationError, "Failed to evaluate #{equation.name} due to #{e.message} in formula #{equation.raw_expression}"
        end
      end
      solution = @bindings.dup
      @bindings.clear
      solution.each_with_object({}) do |kv, hash|
        hash[kv.first] = Hesabu::Types.as_numeric(kv.last) || kv.last
      end
    rescue StandardError => e
      puts "Error during processing: #{$ERROR_INFO}"
      puts "Error : #{e.class} #{e.message}"
      puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      raise e
    end

    def solving_order
      tsort
    rescue TSort::Cyclic => e
      raise Hesabu::CyclicError, "There's a cycle between the variables : " + e.message[25..-1]
    end

    def tsort_each_node(&block)
      @equations.each_key(&block)
    end

    def tsort_each_child(node, &block)
      equation = @equations[node]
      raise UnboundVariableError, unbound_message(node) unless equation
      equation&.dependencies.each(&block)
    end

    private

    def add_numeric(name, raw_expression)
      @equations[name] = Equation.new(
        name,
        FakeEvaluable.new(::Hesabu::Types.as_bigdecimal(raw_expression)),
        EMPTY_DEPENDENCIES,
        raw_expression
      )
    end

    def add_equation(name, raw_expression)
      expression = raw_expression.gsub(/\r\n?/, "")
      ast_tree = begin
        @parser.parse(expression)
      rescue Parslet::ParseFailed => e
        raise ParseError, "failed to parse #{name} := #{expression} : #{e.message}"
      end
      var_identifiers = Set.new
      interpretation = @interpreter.apply(
        ast_tree,
        doc:             @bindings,
        var_identifiers: var_identifiers
      )
      if ENV["HESABU_DEBUG"]
        puts expression
        puts JSON.pretty_generate(ast_tree)
      end
      @equations[name] = Equation.new(name, interpretation, var_identifiers, raw_expression)
    end

    def unbound_message(node)
      ref = first_reference(node)
      "Unbound variable : #{node} used by #{ref.name} (#{ref.raw_expression})"
    end

    def first_reference(variable_name)
      @equations.values.select { |v| v.dependencies.include?(variable_name) }.take(1).first
    end
  end
end
