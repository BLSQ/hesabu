
RSpec.describe Hesabu::Solver do
  let(:solver) { described_class.new }

  describe "support priority between operations" do
    testing_precedence = [
      ["1+2*3/2", "1+((2*3)/2)", "result" => (1 + 2 * 3 / 2)],
      ["-3+1.5*2+5-2*2", "-3+(1.5*2)+5-(2*2)",  "result" => (-3 + 1.5 * 2 + 5 - 2 * 2)],
      ["4 + 3 - 2 +1", "((4 + 3)-2)+1", "result" => (4 + 3 - 2 + 1)],
      ["2 - 3 + 4 -2", "((2-3)+4)-2",  "result" => (2 - 3 + 4 - 2)],
      ["2.4*3 + 1.5*2 - 3.1*4 - 1 +2", "((((2.4*3)+(1.5*2))-(3.1*4))-1) + 2", "result" => (2.4 * 3 + 1.5 * 2 - 3.1 * 4 - 1 + 2)],
      ["if(2 * 4 > 2 + 4, 1,2)", "if((2 * 4) > (2 + 4), 1,2)", "result"=> 2 * 4 > 2 + 4 ? 1 : 2]
    ]

    testing_precedence.each do |test|
      descrition = "\n*******\nprecedence test parse\n\t#{test[0].ljust(50)} \n\t#{test[1].ljust(50)}\n and should return #{test[2]}"
      it descrition do
        solver = described_class.new
        solver.add("a", test[0])
        solver.add("b", test[1])
        solution = solver.solve!
        expect(solution["b"].to_f.round(5)).to eq(test[2]["result"].to_f.round(5))
        expect(solution["a"].to_f.round(5)).to eq(test[2]["result"].to_f.round(5))
      end
    end
  end
end
