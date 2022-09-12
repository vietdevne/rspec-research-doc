require "set"

RSpec.shared_examples "a collection object" do
  describe "<<" do
    it "adds objects to the end of the collection" do
      collection << 1
      collection << 2
      expect(collection.to_a).to match_array([1, 2])
    end
  end
end

RSpec.describe Array do
  it_behaves_like "a collection object" do
    let(:collection) { Array.new }
  end
end

RSpec.describe Set do
  it_behaves_like "a collection object" do
    let(:collection) { Set.new }
  end
end
