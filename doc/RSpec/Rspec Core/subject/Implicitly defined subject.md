# Implicitly defined subject

__1. `subject` top level__

Tạo file `top_level_subject_spec.rb` như sau:
```
RSpec.describe Array do
  it "should be empty when first created" do
    expect(subject).to be_empty
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/top_level_subject_spec.rb -fdoc

Array
  should be empty when first created

Finished in 0.01281 seconds (files took 0.22279 seconds to load)
1 example, 0 failures
```

__2. `subject` trong một nested group__

Tạo file `nested_subject_spec.rb` như sau:
```
RSpec.describe Array do
  describe "when first created" do
    it "should be empty" do
      expect(subject).to be_empty
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/nested_subject_spec.rb -fdoc

Array
  when first created
    should be empty

Finished in 0.00706 seconds (files took 0.21272 seconds to load)
1 example, 0 failure
```

__3. `subject` trong một nested group với 1 class khác (trong cùng sẽ được ưu tiên)__

Tạo file `diff_nested_subject_spec.rb` như sau:
```
class ArrayWithOneElement < Array
  def initialize(*)
    super
    unshift "first element"
  end
end

RSpec.describe Array do
  describe ArrayWithOneElement do
    context "referenced as subject" do
      it "contains one element" do
        expect(subject).to include("first element")
      end
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/diff_nested_subject_spec.rb -fdoc

Array
  ArrayWithOneElement
    referenced as subject
      contains one element

Finished in 0.00974 seconds (files took 0.13263 seconds to load)
1 example, 0 failures
```
