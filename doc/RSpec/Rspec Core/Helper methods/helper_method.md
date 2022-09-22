# Let và let!

## 1. let
Tạo file `let_spec.rb` như sau:
```
$count = 0
RSpec.describe "let" do
  let(:count) { $count += 1 }

  it "memoizes the value" do
    expect(count).to eq(1)
    expect(count).to eq(1)
  end

  it "is not cached across examples" do
    expect(count).to eq(2)
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/helper_methods/let_spec.rb -fdoc     

let
  memoizes the value
  is not cached across examples

Finished in 0.00293 seconds (files took 0.3165 seconds to load)
2 examples, 0 failures
```
## 2. let!
Tạo file `let_bang_spec.rb` như sau:
```
$count = 0
RSpec.describe "let!" do
  invocation_order = []

  let!(:count) do
    invocation_order << :let!
    $count += 1
  end

  it "calls the helper method in a before hook" do
    invocation_order << :example
    expect(invocation_order).to eq([:let!, :example])
    expect(count).to eq(1)
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/helper_methods/let_bang_spec.rb -fdoc

let!
  calls the helper method in a before hook

Finished in 0.00223 seconds (files took 0.19833 seconds to load)
1 example, 0 failures
```

# Helper methods
Chúng ta chỉ cần viết các module helper ở ngoài sau đó require vào file repsec cần helper là có thể sử dụng chúng

Ví dụ:

Tạo file `helpers.rb` như sau:
```
module Helpers
  def help
    :available
  end
end
```

__Include module vào tất cả các example group:__
```
require './helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe "an example group" do
  it "has access to the helper methods defined in the module" do
    expect(help).to be(:available)
  end
end
```
__Extend module vào tất cả các example group:__
```
require './helpers'

RSpec.configure do |c|
  c.extend Helpers
end

RSpec.describe "an example group" do
  puts "Help is #{help}"

  it "does not have access to the helper methods defined in the module" do
    expect { help }.to raise_error(NameError)
  end
end
```

__Include module vào chỉ một vài example group:__
```
require './helpers'

RSpec.configure do |c|
  c.include Helpers, :foo => :bar
end

RSpec.describe "an example group with matching metadata", :foo => :bar do
  it "has access to the helper methods defined in the module" do
    expect(help).to be(:available)
  end
end

RSpec.describe "an example group without matching metadata" do
  it "does not have access to the helper methods defined in the module" do
    expect { help }.to raise_error(NameError)
  end

  it "does have access when the example has matching metadata", :foo => :bar do
    expect(help).to be(:available)
  end
end
```

