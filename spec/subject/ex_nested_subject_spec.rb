RSpec.describe Array do
  subject { [1, 2, 3] }

  describe "has some elements" do
    it "which are the prescribed elements" do
      expect(subject).to eq([1, 2, 3])
    end
  end
end
