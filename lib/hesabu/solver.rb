

module Hesabu
  class Solver
    def initialize
      @equations = {}
    end

    def add(name, raw_expression)
      if raw_expression.nil? || name.nil?
        raise Hesabu::ArgumentError, "name or expression can't be nil : '#{name}', '#{raw_expression}'"
      end
      @equations[name] = EquationCleaner.clean(raw_expression.to_s)
    end

    def solve!
      return {} if @equations.empty?
      result = nil
      IO.popen(HESABUCLI, mode = "r+") do |io|
        io.write @equations.to_json
        io.close_write # let the process know you've given it all the data
        result = io.read
      end
      solution = JSON.parse(result)
      exit_status = $CHILD_STATUS.exitstatus

      log_everything(exit_status, result) if ENV["HESABU_DEBUG"] || exit_status != 0
      handle_error(solution) if exit_status != 0
      solution
    end

    def handle_error(solution)
      error = solution["errors"].first
      message = "In equation #{error['source']} " + error["message"] + " #{error['source']} := #{error['expression']}"

      err = Hesabu::Error.new(message)
      err.errors = solution["errors"]
      raise err
    end

    def log_everything(exit_status, result)
      puts ["**************",
            "exit_status:#{exit_status}",
            @equations.to_json,
            "=> ",
            result].join("\n")
    end
  end
end
