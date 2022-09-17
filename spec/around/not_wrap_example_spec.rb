RSpec.describe "around filter" do
  around(:example) do |example|
    puts "around example before"
    example.run
    puts "around example after"
  end

  before(:context) do
    puts "before context"
  end

  after(:context) do
    puts "after context"
  end

  it "gets run in order" do
    puts "in the example"
  end
end
