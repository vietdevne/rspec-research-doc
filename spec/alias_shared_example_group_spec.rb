RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end

RSpec.shared_examples 'sortability' do
  it 'responds to <=>' do
    expect(sortable).to respond_to(:<=>)
  end
end

RSpec.describe String do
  it_has_behavior 'sortability' do
    let(:sortable) { 'sample string' }
  end
end