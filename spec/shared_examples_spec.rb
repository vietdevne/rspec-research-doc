RSpec.shared_examples "some example" do |parameter|
  let(:something) { parameter }
  it "uses the given parameter" do
    expect(something).to eq(parameter)
  end
end

RSpec.describe SomeClass do
  include_examples "some example", "parameter1"
  include_examples "some example", "parameter2"
end