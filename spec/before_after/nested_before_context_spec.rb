RSpec.describe "something" do
  before :context do
    @value = 123
  end

  describe "nested" do
    it "access state set in before(:context)" do
      expect(@value).to eq(123)
    end

    describe "nested more deeply" do
      it "access state set in before(:context)" do
        expect(@value).to eq(123)
      end
    end
  end

  describe "nested in parallel" do
    it "access state set in before(:context)" do
      expect(@value).to eq(123)
    end
  end
end
