RSpec.describe "an error in before(:context)" do
  before(:context) do
    raise "oops"
  end

  it "fails this example" do
  end

  it "fails this example, too" do
  end

  after(:context) do
    puts "after context ran"
  end

  describe "nested group" do
    it "fails this third example" do
    end

    it "fails this fourth example" do
    end

    describe "yet another level deep" do
      it "fails this last example" do
      end
    end
  end
end
