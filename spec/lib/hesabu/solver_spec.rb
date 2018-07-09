RSpec.describe Hesabu::Solver do
  let(:solver) { described_class.new }
  let(:parser) { Hesabu::Parser.new }
  let(:interpreter) { Hesabu::Interpreter.new }

  it "solves in correct order" do
    solver.add("c", "a + b")
    solver.add("a", "10")
    solver.add("b", "10 + a")

    expect(solver.solve!).to eq("a" => 10, "b" => 20, "c" => 30)
  end

  it "should support AND" do
    solver.add("a", "1")
    solver.add("b", "2")
    solver.add("c", "(a = 1) AND (b=2)")
    expect(solver.solve!).to eq("a" => 1, "b" => 2, "c" => true)
  end

  it "should support AND within a if without parentheses" do
    solver.add("a", "7")
    solver.add("b", "0")
    solver.add("c", "3")
    solver.add("d", "12")
    solver.add("e", "IF(a > 5 AND b=0, c * d, 0.0)")
    expect(solver.solve!).to eq("a" => 7, "b" => 0, "c" => 3, "d" => 12, "e" => 36)
  end

  it "should parse large expression" do
    solver.add("test",
               "if (activity_type = 1, if(increase_percentage < 2.5,safe_div(increase_percentage,2.5) * 100, 100),
           if (activity_type = 2, safe_div(validated,expected) * 100,
           if (activity_type = 3, if(expected = 0, 100, safe_div(validated,expected) * 100),
           if (activity_type = 4, if(status_value = 1,100,
                                  if(increase_percentage >= 1, 100,
                                  if(increase_percentage < 0, 0,
                                  increase_percentage))) * 100,
           if (activity_type = 5, safe_div(validated,number_month) * 100,
           if (activity_type = 6, if (validated >= min_reward,if(additional >= 2,100,50),0),
           if (activity_type = 7, if (validated < 95,validated, 100),
           if (activity_type = 8, if (safe_div(validated,expected) = 0,100,safe_div(validated,expected) * 100),
           if (activity_type = 9, (min(if(expected = 0, 1, safe_div(validated,expected)) * 0.5,0.5) +
                                   min(if(additional2 = 0, 1,safe_div(additional1,additional2)) * 0.5,0.5)) * 100,
           if (activity_type = 10,((if(validated = 20,1,safe_div(validated,20)) * 0.5) + (if(additional  = 2, 1,0.5) * 0.5)) * 100,
           0))))))))))")
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
end
