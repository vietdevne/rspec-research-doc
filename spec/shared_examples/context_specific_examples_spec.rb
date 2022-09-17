RSpec.describe "shared examples" do
  context "per context" do

    shared_examples "shared examples are nestable" do
      specify { expect(true).to eq true }
    end

    it_behaves_like "shared examples are nestable"
  end
end
