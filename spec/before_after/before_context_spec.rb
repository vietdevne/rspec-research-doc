require "rspec/expectations"

class Thing
  def widgets
    @widgets ||= []
  end
end

RSpec.describe Thing do
  before(:context) do
    @thing = Thing.new
  end

  describe "initialized in before(:context)" do
    it "has 0 widgets" do
      expect(@thing.widgets.count).to eq(0)
    end

    it "can accept new widgets" do
      @thing.widgets << Object.new
    end

    it "shares state across examples" do
      expect(@thing.widgets.count).to eq(1)
    end
  end
end
