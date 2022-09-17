require "rspec/expectations"

RSpec.configure do |config|
  config.before(:suite) do
    puts "before suite"
  end

  config.before(:context) do
    puts "before context"
  end

  config.before(:example) do
    puts "before example"
  end

  config.after(:example) do
    puts "after example"
  end

  config.after(:context) do
    puts "after context"
  end

  config.after(:suite) do
    puts "after suite"
  end
end

RSpec.describe "ignore" do
  example "ignore" do
  end
end
