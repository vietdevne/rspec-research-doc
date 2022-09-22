RSpec.describe Array do
  # This uses a context local variable. As you can see from the
  # specs, it can mutate across examples. Use with caution.
  element_list = [1, 2, 3]

  subject { element_list.pop }

  it "is memoized across calls (i.e. the block is invoked once)" do
    expect {
      3.times { subject }
    }.to change{ element_list }.from([1, 2, 3]).to([1, 2])
    expect(subject).to eq(3)
  end

  it "is not memoized across examples" do
    expect{ subject }.to change{ element_list }.from([1, 2]).to([1])
    expect(subject).to eq(2)
  end
end
