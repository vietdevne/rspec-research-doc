RSpec.describe "before and after callbacks" do
  before(:context) do
    puts "outer before context"
  end

  example "in outer group" do
  end

  after(:context) do
    puts "outer after context"
  end

  describe "nested group" do
    before(:context) do
      puts "inner before context"
    end

    example "in nested group" do
    end

    after(:context) do
      puts "inner after context"
    end
  end

end
