RSpec.describe "shared examples" do
  context do
    shared_examples "shared examples are isolated" do
      specify { expect(true).to eq true }
    end
  end

  context do
    it_behaves_like "shared examples are isolated"
  end
end
