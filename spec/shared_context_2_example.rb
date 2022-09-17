require "shared_stuff.rb"

RSpec.describe "including shared context using 'include_context' and a block" do
  include_context "shared stuff" do
    let(:shared_let) { {'in_a' => 'block'} }
  end

  it "evaluates the block in the shared context" do
    expect(shared_let['in_a']).to eq('block')
  end
end
