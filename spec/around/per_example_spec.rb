RSpec.describe "around filter" do
  around(:example) do |example|
    puts "around example before"
    example.run
    puts "around example after"
  end

  before(:example) do
    puts "before example"
  end

  after(:example) do
    puts "after example"
  end

  it "gets run in order" do
    puts "in the example"
  end
end
