

RSpec.describe Hesabu::EquationCleaner do
  let(:subject) { described_class }
  describe "boolean AND" do
    it "replace AND by && " do
      expect(subject.clean("sample AND basic")).to eq("sample && basic")
    end

    it "keep && uncleaned " do
      expect(subject.clean("sample && basic")).to eq("sample && basic")
    end
  end

  describe "= replace by ==" do
    ["a<=basic", "a>=basic", "a==basic", "a!=basic",
     "a <=basic", "a >=basic", "a ==basic", "a!= basic",
     "a <= basic", "a >= basic", "a == basic", "a != basic",
     "a<= basic", "a>= basic", "a== basic", "a !=basic"].each do |expression|
      it "leave the #{expression} untouched" do
        expect(subject.clean(expression)).to eq(expression)
      end
    end
    { "a=b"  => "a==b",
      "a =b" => "a ==b",
      "a= b" => "a== b",
      "a= b" => "a== b" }.each do |exp, expected|
      it "replace #{exp} to #{expected} " do
        expect(subject.clean(exp)).to eq(expected)
      end
    end
  end
end
