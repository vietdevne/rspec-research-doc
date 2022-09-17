RSpec.describe "shared examples" do
  shared_examples "shared examples are nestable" do
    specify { expect(true).to eq true }
  end

  context "per context" do
    it_behaves_like "shared examples are nestable"
  end
end
