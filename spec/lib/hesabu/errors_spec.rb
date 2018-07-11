RSpec.describe Hesabu::Solver do
  let(:solver) { described_class.new }

  it "fails when no value provided" do
    solver.add("a", "missing_var * 1")
    expect { solver.solve! }.to raise_error(
      Hesabu::Error,
      "In equation a No parameter 'missing_var' found. a := missing_var * 1"
    )
  end

  it "fails when dividing by 0" do
    solver.add("a", "0")
    solver.add("b", "10 / a")
    expect { solver.solve! }.to raise_error(
      Hesabu::Error,
      "In equation b Divide by zero b := 10 / a"
    )
  end

  it "fails when a cycle" do
    solver.add("a", "10 / (b *c) ")
    solver.add("b", "a")
    solver.add("c", "1")
    expect { solver.solve! }.to raise_error(
      Hesabu::Error,
      'In equation general cycle between equations general := general'
    )
  end

  describe "Hesabu::ArgumentError" do
    it "fails when nil" do
      expect { solver.add("c", nil) }.to raise_error(
        Hesabu::Error,
        "name or expression can't be nil : 'c', ''"
      )
    end

    it "fails when nil" do
      expect { solver.add(nil, "1") }.to raise_error(
        Hesabu::Error,
        "name or expression can't be nil : '', '1'"
      )
    end


  end

  describe "Hesabu::Error" do

    it "fails when nil" do
      expect { solver.add("sample_cast_error", "if(1,2,3)"); solver.solve! }.to raise_error(
        Hesabu::Error,
        "In equation sample_cast_error Evaluation failed interface conversion: interface {} is float64, not bool <nil> sample_cast_error := if(1,2,3)"
      )
    end
    it "fails when not parsable" do
      expect { solver.add("a", "a b"); solver.solve! }.to raise_error(
        Hesabu::Error,
        "In equation a Cannot transition token types from VARIABLE [a] to VARIABLE [b] a := a b"
        )
    end
    it "fails when not parsable" do
      expect { solver.add("a", ""); solver.solve! }.to raise_error(
        Hesabu::Error,
        "In equation a Unexpected end of expression a := "
        )
    end
    it "fails when not parsable : bad number format" do
      expect { solver.add("a", "545.5454.54"); solver.solve! }.to raise_error(
        Hesabu::Error, "In equation a Unable to parse numeric value '545.5454.54' to float64\n a := 545.5454.54"
      )
    end
    it "fails when not parsable : missing parentheses" do
      expect { solver.add("a", "if(1>2,3,4"); solver.solve! }.to raise_error(
        Hesabu::Error,
        "In equation a Unbalanced parenthesis a := if(1>2,3,4"
      )
    end
    it "fails when not parsable : missing quote" do
      expect { solver.add("a", "'sampl"); solver.solve! }.to raise_error(
        Hesabu::Error,
        "In equation a Unclosed string literal a := 'sampl"
      )
    end
  end
end
