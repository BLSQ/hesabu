
RSpec.describe Hesabu::Solver do
  let(:solver) { described_class.new }

  describe "support various equations" do
    let(:bindings) { { "bb" => 4 } }

    def self.as_bigdecimal(val)
      ::Hesabu::Types.as_bigdecimal(val)
    end
    TESTS = [
      ["1", "result" => 1],
      ["0", "result" => 0],
      ["-1", "result" => -1],
      ["1.0", "result" => 1],
      ["0.35", "result"=> 0.35],
      [".35", "result"=> 0.35],
      ["4567.35", "result"=> 4567.35],
      ["1+1 ", "result" => 2],
      ["1 + 1 ", "result" => 2],
      ["(1 + 1)", "result" => 2],
      ["(1 - 1)", "result" => 0],
      ["1.0+1.0", "result" => 2],
      ["1 + 1.0 ", "result" => 2],
      ["1.0 - 1.0 ", "result" => 0],
      ["1.0 / 1.0 ", "result" => 1.0],
      ["4 / 2 ", "result" => 2],
      ["4 / 3 ", "result" => 1.3333333333333333],
      ["2.5 / 0.5 ", "result" => 5],
      ["2.5 / 2 ", "result" => 1.25],
      ["(100 / 3) * 3 ", "result" => 100],
      ["round((100 / 3) * 3)", "result" => 100],
      ["ROUND((100 / 3) * 3, 4)", "result" => 100],
      ["round((100 / 3), 4)", "result" => as_bigdecimal("33.3333")],
      ["2.5 * 3 ", "result" => 7.5],
      [".35 * bb", "result"=> 1.4],
      ["1 > 2 ", "result" => false],
      ["1 < 2 ", "result" => true],
      ["1 = 2 ", "result" => false],
      ["1 = 1 ", "result" => true],
      ["1 < 2 ", "result" => true],
      ["2< 1.5 ", "result" => false],
      ["2<= 1.5 ", "result" => false],
      ["2<= 2 ", "result" => true],
      ["2>= 2 ", "result" => true],
      ["2>= 1.5 ", "result" => true],
      ["abs(1)", "result" => 1],
      ["abs(-1)", "result" => 1],
      ["abs(-5.5)", "result" => 5.5],
      ["abs(17.5)", "result" => 17.5],
      ["abs(0)", "result" => 0],
      ["SUM(1,1.5,3) ", "result" => 5.5],
      ["SUM(bb,cc+1.5 + 3)", "result" => 8.5],
      ["sum(bb,cc + 1.5+3)", "result" => 8.5],
      ["SUM(bb, cc + 1.5 + 3 )", "result" => 8.5],
      ["SUM( bb, cc + 1.5+3 )", "result" => 8.5],
      ["SUM ( bb, cc + 1.5 + 3 )",  "result" => 8.5],
      ["sum ( bb, cc + 1.5 +3)",  "result" => 8.5],
      ["IF (bb<5,1,4)", "result" => 1],
      ["if((bb<5) , 1 ,4)", "result" => 1],
      ["if(bb < 5,1,4)", "result" => 1],
      ["if(bb > 3,1,4)", "result" => 1],
      ["if(bb > 5,1,4)", "result" => 4],
      ["if(bb = 5,1,4)", "result" => 4],
      ["if(bb = 4,1,4)", "result" => 1],
      ["if (bb == 5,1,4)", "result" => 4],
      ["if(bb == 4,1,4)", "result" => 1],
      ["avg(1,2,5)", "result" => 2.6666666666666665],
      ["AVG(0,74.19354838709677,71.21212121212122)",
       "result" => 48.468556533072665],
      ["if(2 == 1, SUM(0,74.19354838709677,71.21212121212122), avg(0,74.19354838709677,71.21212121212122))",
       "result" => 48.468556533072665],
      ["(9.25925925925926/100)*76.92307692307693",
       "result" => 7.122507122507124],
      ["AVG(0,74.19354838709677,71.21212121212122)*3",
       "result" => 145.405669599218],
      ["min( 1.0 ,2,5)", "result" => 1.0],
      ["max(1,2, 5 )", "result" => 5],
      ["safe_div(1, 4 )", "result" => 0.25],
      ["SAFE_DIV(1, 0 )", "result" => 0],
      ["score_Table(0, 0,2,30 , 2,4,50, 4,6, 70 )", "result" => 30],
      ["SCORE_TABLE(1, 0,2,30 , 2,4,50, 4,6, 70 )", "result" => 30],
      ["score_Table(2, 0,2,30 , 2,4,50, 4,6, 70 )", "result" => 50],
      ["score_table(3, 0,2,30 , 2,4,50, 4,6, 70 )", "result" => 50],
      ["score_Table(4, 0,2,30 , 2,4,50, 4,6, 70 )", "result" => 70],
      ["score_Table(5, 0,2,30 , 2,4,50, 4,6, 70 )", "result" => 70],
      ["score_Table(6, 0,2,30 , 2,4,50, 4,6, 70, 200 )", "result" => 200],
      ["score_Table(7, 0,2,30 , 2,4,50, 4,6, 70, 200 )", "result" => 200],
      ["score_Table(8, 0,2,30 , 2,4,50, 4,6, 70, 200)", "result" => 200 ],
      ["access( 1,2,3,4, 0)", "result" => 1],
      ["ACCESS( 1,2,3,4, 3)", "result" => 4],
      ["if('aa' == 'bb', 1, 2)", "result" => 2],
      ["if('aa' == 'aa', 1, 2)", "result" => 1]
    ].freeze

    TESTS.each do |test|
      it "parse #{test[0].ljust(50)} and should return #{test[1]}" do
        test_parsing(*test)
      end
    end

    def test_parsing(input, expected_binding = {})

      solver = Hesabu::Solver.new
      solver.add("result", input)
      solver.add("bb", 4)
      solver.add("cc", 0)
      solution = solver.solve!
      solution.delete("bb")
      solution.delete("cc")

      case solution["result"]
      when Float, Integer, BigDecimal
        expect(solution["result"]).to be_within(0.000001).of(expected_binding["result"])
      else
        expect(solution["result"]).to eq(expected_binding["result"])
      end
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
