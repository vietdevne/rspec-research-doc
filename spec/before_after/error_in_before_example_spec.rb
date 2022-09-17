RSpec.describe "error in before(:example)" do
  before(:example) do
    raise "this error"
  end

  it "is reported as failure" do
  end
end
