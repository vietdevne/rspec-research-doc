# Shared examples
Shared examples cho phép mô tả hành vi của các class hoặc module. Khi được khai báo, nội dung của một Shared examples sẽ được lưu trữ. Nó chỉ được thực hiện trong ngữ cảnh của
một nhóm ví dụ khác, nhóm này cung cấp bất kỳ ngữ cảnh nào mà nhóm được chia sẻ cần để
chạy.

Ví dụ như có 2 controler là UsersController và PostsController, index của cả 2 đều trả về list tất cả các records (User.all và Post.all) thì chúng ta sẽ cần một shared_example index để tránh lặp lại trong khi viết rspec.

Sử dụng Shared examples bằng các cách sau:
```
include_examples "name"      # includes examples trong context hiện tại
it_behaves_like "name"       # include examples trong nested context.
it_should_behave_like "name" # như trên
```
__Lưu ý:__ 
- các file chứa Shared examples phải được load trước các file sử dụng chúng
- Khi đưa vào các tham số vào Shared examples giống nhau sẽ bị ghi đè và nó sẽ sử dụng tham số được khai báo cuối cùng

## Các ví dụ:
__- Shared example include vào 2 group trong 1__ file

Tạo file `collection_spec.rb` như sau:
```
require "set"

RSpec.shared_examples "a collection" do
  let(:collection) { described_class.new([7, 2, 4]) }

  context "initialized with 3 items" do
    it "says it has three items" do
      expect(collection.size).to eq(3)
    end
  end

  describe "#include?" do
    context "with an item that is in the collection" do
      it "returns true" do
        expect(collection.include?(7)).to be(true)
      end
    end

    context "with an item that is not in the collection" do
      it "returns false" do
        expect(collection.include?(9)).to be(false)
      end
    end
  end
end

RSpec.describe Array do
  it_behaves_like "a collection"
end

RSpec.describe Set do
  it_behaves_like "a collection"
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/collection_spec.rb -fdoc

Array
  behaves like a collection
    initialized with 3 items
      says it has three items
    #include?
      with an item that is in the collection
        returns true
      with an item that is not in the collection
        returns false

Set
  behaves like a collection
    initialized with 3 items
      says it has three items
    #include?
      with an item that is in the collection
        returns true
      with an item that is not in the collection
        returns false

Finished in 0.00456 seconds (files took 0.0923 seconds to load)
6 examples, 0 failures
```

__-  Sử dụng block:__

Tạo file `shared_example_group_spec.rb` như sau:
```
require "set"

RSpec.shared_examples "a collection object" do
  describe "<<" do
    it "adds objects to the end of the collection" do
      collection << 1
      collection << 2
      expect(collection.to_a).to match_array([1, 2])
    end
  end
end

RSpec.describe Array do
  it_behaves_like "a collection object" do
    let(:collection) { Array.new }
  end
end

RSpec.describe Set do
  it_behaves_like "a collection object" do
    let(:collection) { Set.new }
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/shared_example_group_spec.rb -fdoc

Array
  behaves like a collection object
    <<
      adds objects to the end of the collection

Set
  behaves like a collection object
    <<
      adds objects to the end of the collection

Finished in 0.00275 seconds (files took 0.09463 seconds to load)
2 examples, 0 failures
```

__- Truyền params vào shared exmaples:__
Tạo file `shared_example_group_params_spec.rb` như sau:
```
RSpec.shared_examples "a measurable object" do |measurement, measurement_methods|
  measurement_methods.each do |measurement_method|
    it "should return #{measurement} from ##{measurement_method}" do
      expect(subject.send(measurement_method)).to eq(measurement)
    end
  end
end

RSpec.describe Array, "with 3 items" do
  subject { [1, 2, 3] }
  it_should_behave_like "a measurable object", 3, [:size, :length]
end

RSpec.describe String, "of 6 characters" do
  subject { "FooBar" }
  it_should_behave_like "a measurable object", 6, [:size, :length]
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/shared_example_group_params_spec.rb -fdoc

Array with 3 items
  it should behave like a measurable object
    should return 3 from #size
    should return 3 from #length

String of 6 characters
  it should behave like a measurable object
    should return 6 from #size
    should return 6 from #length

Finished in 0.00246 seconds (files took 0.09284 seconds to load)
4 examples, 0 failures
```

__- Sử dụng alias: `it_should_behave_like` thành `it_has_behavior` :__

Tạo file `alias_shared_example_group_spec.rb` như sau:
```
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
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/alias_shared_example_group_spec.rb -fdoc

String
  has behavior: sortability
    responds to <=>

Finished in 0.00478 seconds (files took 0.08905 seconds to load)
1 example, 0 failures
```

__- Shared examples có thể lồng vào nhau bởi context:__

Tạo file `context_specific_examples_spec.rb` như sau:
```
RSpec.describe "shared examples" do
  context "per context" do

    shared_examples "shared examples are nestable" do
      specify { expect(true).to eq true }
    end

    it_behaves_like "shared examples are nestable"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/context_specific_examples_spec.rb -fdoc

shared examples
  per context
    behaves like shared examples are nestable
      is expected to eq true

Finished in 0.00137 seconds (files took 0.08829 seconds to load)
1 example, 0 failures
```
__- Shared examples có thể truy cập được từ các contexts con:__

Tạo file `con_context_specific_examples_spec.rb` như sau:
```
RSpec.describe "shared examples" do
  shared_examples "shared examples are nestable" do
    specify { expect(true).to eq true }
  end

  context "per context" do
    it_behaves_like "shared examples are nestable"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/con_context_specific_examples_spec.rb -fdoc

shared examples
  per context
    behaves like shared examples are nestable
      is expected to eq true

Finished in 0.00156 seconds (files took 0.09518 seconds to load)
1 example, 0 failures
```

__- Shared examples được tách biệt theo từng context:__

Tạo file `isolated_shared_examples_spec.rb` như sau:
```
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
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/isolated_shared_examples_spec.rb -fdoc

An error occurred while loading ./spec/isolated_shared_examples_spec.rb.
Failure/Error: it_behaves_like "shared examples are isolated"

ArgumentError:
  Could not find shared examples "shared examples are isolated"
```
