


RSpec.describe Hesabu::Types do
    let(:subject) { described_class }

    it "transform numeric" do
       expect(subject.as_numeric("0.2456")).to eq(0.2456)
       expect(subject.as_numeric("5.0")).to eq(5)
       expect(subject.as_numeric("5")).to eq(5)
       expect(subject.as_numeric(5)).to eq(5)
       expect(subject.as_numeric(5.5)).to eq(5.5)
    end
end