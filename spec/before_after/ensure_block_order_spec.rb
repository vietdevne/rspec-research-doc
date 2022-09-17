require "rspec/expectations"

RSpec.describe "before and after callbacks" do
  before(:context) do
    puts "before context"
  end

  before(:example) do
    puts "before example"
  end

  before do
    puts "also before example but by default"
  end

  after(:example) do
    puts "after example"
  end

  after do
    puts "also after example but by default"
  end

  after(:context) do
    puts "after context"
  end

  it "gets run in order" do

  end
end
