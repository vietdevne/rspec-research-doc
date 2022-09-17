RSpec.configure do |c|
  c.around(:example) do |example|
    puts "around example before"
    example.run
    puts "around example after"
  end
end

RSpec.describe "around filter" do
  it "gets run in order" do
    puts "in the example"
  end
end
