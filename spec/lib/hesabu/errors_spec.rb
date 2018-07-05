RSpec.describe Hesabu::Solver do
  let(:solver) { described_class.new }

  it "fails when no value provided" do
    solver.add("a", "missing_var * 1")
    expect { solver.solve! }.to raise_error(
      Hesabu::UnboundVariableError,
      "Unbound variable : missing_var used by a (missing_var * 1)"
    )
  end

  it "fails when dividing by 0" do
    solver.add("a", "0")
    solver.add("b", "10 / a")
    expect { solver.solve! }.to raise_error(
      Hesabu::CalculationError,
      "Failed to evaluate b due to division by 0 : 0.1e2/0 in formula 10 / a"
    )
  end

  it "fails when a cycle" do
    solver.add("a", "10 / (b *c) ")
    solver.add("b", "a")
    solver.add("c", "1")
    expect { solver.solve! }.to raise_error(
      Hesabu::CyclicError,
      'There\'s a cycle between the variables : ["a", "b"]'
    )
  end

  describe "Hesabu::ArgumentError" do
    it "fails when nil" do
      expect { solver.add("c", nil) }.to raise_error(
        Hesabu::ArgumentError,
        "name or expression can't be nil : 'c', ''"
      )
    end

    it "fails when nil" do
      expect { solver.add(nil, "1") }.to raise_error(
        Hesabu::ArgumentError,
        "name or expression can't be nil : '', '1'"
      )
    end
  end

  describe "Hesabu::ParseError" do
    it "fails when not parsable" do
      expect { solver.add("a", "a b") }.to raise_error(Hesabu::ParseError)
    end
    it "fails when not parsable" do
      expect { solver.add("a", "") }.to raise_error(Hesabu::ParseError)
    end
    it "fails when not parsable : bad number format" do
      expect { solver.add("a", "545.5454.54") }.to raise_error(Hesabu::ParseError)
    end
    it "fails when not parsable : missing parentheses" do
      expect { solver.add("a", "if(1>2,3,4") }.to raise_error(Hesabu::ParseError)
    end
    it "fails when not parsable : missing quote" do
      expect { solver.add("a", "'sampl")  }.to raise_error(Hesabu::ParseError)
    end
  end
end
