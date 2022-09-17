# RSpec.describe "if there are multiple around hooks in the same scope" do
#   around(:example) do |example|
#     puts "first around hook before"
#     example.run
#     puts "first around hook after"
#   end

#   around(:example) do |example|
#     puts "second around hook before"
#     example.run
#     puts "second around hook after"
#   end

#   it "they should all be run" do
#     puts "in the example"
#     expect(1).to eq(1)
#   end
# end


RSpec.describe "if there are around hooks in an outer scope" do
  around(:example) do |example|
    puts "first outermost around hook before"
    example.run
    puts "first outermost around hook after"
  end

  around(:example) do |example|
    puts "second outermost around hook before"
    example.run
    puts "second outermost around hook after"
  end

  describe "outer scope" do
    around(:example) do |example|
      puts "first outer around hook before"
      example.run
      puts "first outer around hook after"
    end

    around(:example) do |example|
      puts "second outer around hook before"
      example.run
      puts "second outer around hook after"
    end

    describe "inner scope" do
      around(:example) do |example|
        puts "first inner around hook before"
        example.run
        puts "first inner around hook after"
      end

      around(:example) do |example|
        puts "second inner around hook before"
        example.run
        puts "second inner around hook after"
      end

      it "they should all be run" do
        puts "in the example"
      end
    end
  end
end
