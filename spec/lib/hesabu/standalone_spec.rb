require "open3"
require "rbconfig"

# Runs the solver in a fresh ruby process where oj is not loadable and nothing
# else preloaded English, like a host app without oj (plain json fallback).
RSpec.describe "Hesabu without oj nor preloaded libs" do
  LIB = File.expand_path("../../../lib", __dir__)
  PRELUDE = <<~RUBY.freeze
    abort "English already loaded" if $LOADED_FEATURES.grep(/English/).any?
    Object.prepend(Module.new { def require(name) = name == "oj" ? raise(LoadError, name) : super })
    require "hesabu"
    abort "oj should not be loaded" if defined?(Oj)
  RUBY

  def run_standalone(script)
    out, err, status = Open3.capture3(RbConfig.ruby, "-I", LIB, "-e", PRELUDE + script)
    expect(status).to be_success, "standalone ruby failed:\n#{err}"
    out
  end

  it "solves equations with the stdlib json" do
    out = run_standalone(<<~RUBY)
      solver = Hesabu::Solver.new
      solver.add("a", "1 + 2")
      solver.add("b", "a * 3")
      solution = solver.solve!
      print JSON.generate(solution)
    RUBY
    expect(out).to eq('{"a":3,"b":9}')
  end

  it "raises Hesabu::Error with the failing equation" do
    out = run_standalone(<<~RUBY)
      solver = Hesabu::Solver.new
      solver.add("a", "b + 1")
      begin
        solver.solve!
      rescue Hesabu::Error => e
        print e.message
      end
    RUBY
    expect(out).to include("In equation a").and include("a := b + 1")
  end
end
