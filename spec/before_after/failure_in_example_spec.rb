RSpec.describe "a failing example does not affect hooks" do
  before(:context) { puts "before context runs" }
  before(:example) { puts "before example runs" }
  after(:example) { puts "after example runs" }
  after(:context) { puts "after context runs" }

  it "fails the example but runs the hooks" do
    raise "An Error"
  end
end
