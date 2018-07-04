RSpec.describe Hesabu::Solver do
  let(:solver) { described_class.new }
  let(:parser) { Hesabu::Parser.new }
  let(:interpreter) { Hesabu::Interpreter.new }

  it "solves in correct order" do
    solver.add("c", "a + b")
    solver.add("a", "10")
    solver.add("b", "10 + a")
    expect(solver.solving_order).to eq(%w[a b c])

    expect(solver.solve!).to eq("a" => 10, "b" => 20, "c" => 30)
  end

  it "should support AND" do
    solver.add("a", "1")
    solver.add("b", "2")
    solver.add("c", "(a = 1) AND (b=2)")
    expect(solver.solve!).to eq("a" => 1, "b" => 2, "c" => true)

      
  end

  it "solves equation with parentheses" do
    solver.add("a", "10")
    solver.add("b", "10 + a")
    solver.add("c", "(a + b) * 4")
    expect(solver.solve!).to eq("a" => 10, "b" => 20, "c" => 120)
  end

  it "solves equation with parentheses" do
    solver.add("a", "10")
    solver.add("b", "10 + a")
    expect(solver.solve!).to eq("a" => 10, "b" => 20)
  end

  it "solver equation with randbetween" do
    solver.add("a", "10")
    solver.add("b", "randbetween(4,7) + a")
    solution = solver.solve!
    expect(solution["a"]).to eq(10)
    expect(solution["b"]).to be_between(14, 17)
  end

  it "should allow string comparison" do
    solver.add("a", "'quotedstring'")
    solver.add("b", "if(a == 'quotedstring', 1,2)")
    solver.add("c", "if(a != 'quotedstring', 1,2)")
    solution = solver.solve!
    expect(solution["a"]).to eq("quotedstring")
    expect(solution["b"]).to eq(1)
    expect(solution["c"]).to eq(2)
  end

  describe "support various equations" do
    let(:bindings) { { "bb" => 4 } }

    TESTS = [
      ["1", "bb" => 4, "result" => 1],
      ["0", "bb" => 4, "result" => 0],
      ["-1", "bb" => 4, "result" => -1],
      ["1.0", "bb" => 4, "result" => 1],
      ["1+1 ", "bb" => 4, "result" => 2],
      ["1 + 1 ", "bb" => 4, "result" => 2],
      ["(1 + 1)", "bb" => 4, "result" => 2],
      ["(1 - 1)", "bb" => 4, "result" => 0],
      ["1.0+1.0", "bb" => 4, "result" => 2],
      ["1 + 1.0 ", "bb" => 4, "result" => 2],
      ["1.0 - 1.0 ", "bb" => 4, "result" => 0],
      ["1.0 / 1.0 ", "bb" => 4, "result" => 1.0],
      ["4 / 2 ", "bb" => 4, "result" => 2],
      ["4 / 3 ", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("0.1333333333333333333e1")],
      ["2.5 / 0.5 ", "bb" => 4, "result" => 5],
      ["2.5 / 2 ", "bb" => 4, "result" => 1.25],
      ["(100 / 3) * 3 ", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("0.99999999999999999999e2")],
      ["round((100 / 3) * 3)", "bb" => 4, "result" => 100],
      ["round((100 / 3) * 3, 4)", "bb" => 4, "result" => 100],
      ["round((100 / 3), 4)", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("33.3333")],
      ["2.5 * 3 ", "bb" => 4, "result" => 7.5],
      ["1 > 2 ", "bb" => 4, "result" => false],
      ["1 < 2 ", "bb" => 4, "result" => true],
      ["1 = 2 ", "bb" => 4, "result" => false],
      ["1 = 1 ", "bb" => 4, "result" => true],
      ["1 < 2 ", "bb" => 4, "result" => true],
      ["2< 1.5 ", "bb" => 4, "result" => false],
      ["2<= 1.5 ", "bb" => 4, "result" => false],
      ["2<= 2 ", "bb" => 4, "result" => true],
      ["2>= 2 ", "bb" => 4, "result" => true],
      ["2>= 1.5 ", "bb" => 4, "result" => true],
      ["abs(1)", "bb" => 4, "result" => 1],
      ["abs(-1)", "bb" => 4, "result" => 1],
      ["abs(-5.5)", "bb" => 4, "result" => 5.5],
      ["abs(17.5)", "bb" => 4, "result" => 17.5],
      ["abs(0)", "bb" => 4, "result" => 0],
      ["SUM(1,1.5,3) ", "bb" => 4, "result" => 5.5],
      ["SUM(bb,cc+1.5 + 3)", "bb" => 4, "cc" => 0, "result" => 8.5],
      ["SUM(bb,cc + 1.5+3)", "bb" => 4, "cc" => 0, "result" => 8.5],
      ["SUM(bb, cc + 1.5 + 3 )", "bb" => 4, "cc" => 0, "result" => 8.5],
      ["SUM( bb, cc + 1.5+3 )", "bb" => 4, "cc" => 0, "result" => 8.5],
      ["SUM ( bb, cc + 1.5 + 3 )", "bb" => 4, "cc" => 0, "result" => 8.5],
      ["sum ( bb, cc + 1.5 +3)", "bb" => 4, "cc" => 0, "result" => 8.5],
      ["IF (bb<5,1,4)", "bb" => 4, "result" => 1],
      ["if((bb<5) , 1 ,4)", "bb" => 4, "result" => 1],
      ["if(bb < 5,1,4)", "bb" => 4, "result" => 1],
      ["if(bb > 3,1,4)", "bb" => 4, "result" => 1],
      ["if(bb > 5,1,4)", "bb" => 4, "result" => 4],
      ["if(bb = 5,1,4)", "bb" => 4, "result" => 4],
      ["if(bb = 4,1,4)", "bb" => 4, "result" => 1],
      ["if (bb == 5,1,4)", "bb" => 4, "result" => 4],
      ["if(bb == 4,1,4)", "bb" => 4, "result" => 1],
      ["avg(1,2,5)", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("0.2666666666666666667e1")],
      ["AVG(0,74.19354838709677,71.21212121212122)", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("48.468556533072663333333333333333333333")],
      ["if(2 == 1,         SUM(0,74.19354838709677,71.21212121212122),        AVG(0,74.19354838709677,71.21212121212122))", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("48.468556533072663333333333333333333333")],
      ["(9.25925925925926/100)*76.92307692307693", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("0.7122507122507123717948717948718e1")],
      ["AVG(0,74.19354838709677,71.21212121212122)*3", "bb" => 4, "result" => ::Hesabu::Types.as_bigdecimal("0.145405669599217989999999999999999999999e3")],
      ["min( 1.0 ,2,5)", "bb" => 4, "result" => 1.0],
      ["max(1,2, 5 )", "bb" => 4, "result" => 5],
      ["safe_div(1, 4 )", "bb" => 4, "result" => 0.25],
      ["safe_div(1, 0 )", "bb" => 4, "result" => 0],
      ["score_Table(0, 0,2,30 , 2,4,50, 4,6, 70 )", "bb" => 4, "result" => 30],
      ["score_Table(1, 0,2,30 , 2,4,50, 4,6, 70 )", "bb" => 4, "result" => 30],
      ["score_Table(2, 0,2,30 , 2,4,50, 4,6, 70 )", "bb" => 4, "result" => 50],
      ["score_Table(3, 0,2,30 , 2,4,50, 4,6, 70 )", "bb" => 4, "result" => 50],
      ["score_Table(4, 0,2,30 , 2,4,50, 4,6, 70 )", "bb" => 4, "result" => 70],
      ["score_Table(5, 0,2,30 , 2,4,50, 4,6, 70 )", "bb" => 4, "result" => 70],
      ["access( 1,2,3,4, 0)", "bb" => 4, "result" => 1],
      ["access( 1,2,3,4, 3)", "bb" => 4, "result" => 4],
      ["if('aa' == 'bb', 1, 2)", "bb" => 4, "result" => 2],
      ["if('aa' == 'aa', 1, 2)", "bb" => 4, "result" => 1]
    ].freeze

    TESTS.each do |test|
      it "parse #{test[0].ljust(50)} and should return #{test[1]}" do
        test_parsing(*test)
      end
    end

    def test_parsing(input, expected_binding = {})
      @logs = []

      tree = parser.parse(input.gsub(/\r\n?/, "\n"))
      log "-------------------- " + input
      log "******* PARSING "
      pp tree
      log "******* TRANSFORM"
      bindings = { "bb" => 4 }
      result   = interpreter.apply(tree, doc: bindings)
      pp result
      log "******* EVAL"
      raise "no eval methods for #{result.inspect} " unless result.respond_to?(:eval)
      eval_result = result.eval
      pp eval_result
      pp bindings
      bindings["result"] = eval_result
      log "-------"
      expect(bindings).to eq(expected_binding)
    rescue Parslet::ParseFailed => e
      puts "#{input} vs #{expected_binding} =>  #{e.class} : #{e.message}"
      puts e&.parse_failure_cause&.ascii_tree
      raise e
    rescue StandardError => e
      puts "#{input} vs #{expected_binding} =>  #{e.class} : #{e.message}"
      raise e
    end

    def pp(object)
      @logs << object.inspect
    end

    def log(message)
      @logs << message
    end
  end
end
