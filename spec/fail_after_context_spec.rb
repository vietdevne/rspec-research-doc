RSpec.describe "an error in after(:context)" do
  after(:context) do
    raise StandardError.new("Boom!")
  end

  it "passes this example" do
  end

  it "passes this example, too" do
  end
end
