RSpec.describe "implicit pending example" do
  around(:example) do |example|
    example.run
  end

  it "should be detected as Not yet implemented"

  it "should be detected as pending" do
    pending
    fail
  end
end
