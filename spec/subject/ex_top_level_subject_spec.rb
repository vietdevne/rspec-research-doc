RSpec.describe Array, "with some elements" do
  subject { [1, 2, 3] }

  it "has the prescribed elements" do
    expect(subject).to eq([1, 2, 3])
  end
end
