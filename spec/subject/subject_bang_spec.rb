RSpec.describe "eager loading with subject!" do
  subject! { element_list.push(99) }

  let(:element_list) { [1, 2, 3] }

  it "calls the definition block before the example" do
    element_list.push(5)
    expect(element_list).to eq([1, 2, 3, 99, 5])
  end
end
