# Shared context
Cũng tương tự như shared example, chúng ta sẽ tìm hiểu cách sử dụng thông qua các trường hợp dưới đây

## 1. Chuẩn bị
Tạo file `shared_stuff.rb` như sau:
```
RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4,
  # but for reasons of backwards compatibility, you have to
  # set it on RSpec 3.
  #
  # It causes the host group and examples to inherit metadata
  # from the shared context.
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "shared stuff", :shared_context => :metadata do
  before { @some_var = :some_value }
  def shared_method
    "it works"
  end
  let(:shared_let) { {'arbitrary' => 'object'} }
  subject do
    'this is the subject'
  end
end

RSpec.configure do |rspec|
  rspec.include_context "shared stuff", :include_shared => true
end
```

## 2. Các trường hợp ví dụ
__- Khai báo 1 shared context và include nó với `include_context`:__

Tạo file `shared_context_example.rb` như sau:
```
require "shared_contexts/shared_stuff.rb"

RSpec.describe "group that includes a shared context using 'include_context'" do
  include_context "shared stuff"

  it "has access to methods defined in shared context" do
    expect(shared_method).to eq("it works")
  end

  it "has access to methods defined with let in shared context" do
    expect(shared_let['arbitrary']).to eq('object')
  end

  it "runs the before hooks defined in the shared context" do
    expect(@some_var).to be(:some_value)
  end

  it "accesses the subject defined in the shared context" do
    expect(subject).to eq('this is the subject')
  end

  group = self

  it "inherits metadata from the included context" do |ex|
    expect(group.metadata).to include(:shared_context => :metadata)
    expect(ex.metadata).to include(:shared_context => :metadata)
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/shared_contexts/shared_context_example.rb -fdoc

group that includes a shared context using 'include_context'
  has access to methods defined in shared context
  has access to methods defined with let in shared context
  runs the before hooks defined in the shared context
  accesses the subject defined in the shared context
  inherits metadata from the included context

Finished in 0.00911 seconds (files took 0.11881 seconds to load)
5 examples, 0 failures

```
__- Khai báo 1 shared context, include nó với `include_context` và extend với 1 block__

Tạo file `shared_context_2_example.rb` như sau:
```
require "shared_contexts/shared_stuff.rb"

RSpec.describe "including shared context using 'include_context' and a block" do
  include_context "shared stuff" do
    let(:shared_let) { {'in_a' => 'block'} }
  end

  it "evaluates the block in the shared context" do
    expect(shared_let['in_a']).to eq('block')
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/shared_contexts/shared_context_2_example.rb -fdoc

including shared context using 'include_context' and a block
  evaluates the block in the shared context

Finished in 0.00089 seconds (files took 0.11533 seconds to load)
1 example, 0 failures
```
