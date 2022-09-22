# Explicit Subject

__1. Một `subject` có thể được define và sử dụng trong phạm vi group cao nhất__

Tạo file `ex_top_level_subject_spec.rb` như sau:
```
RSpec.describe Array, "with some elements" do
  subject { [1, 2, 3] }

  it "has the prescribed elements" do
    expect(subject).to eq([1, 2, 3])
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/ex_top_level_subject_spec.rb -fdoc

Array with some elements
  has the prescribed elements

Finished in 0.001 seconds (files took 0.11526 seconds to load)
1 example, 0 failures
```

__2. `subject` được define bên ngoài group vẫn có ảnh hưởng tới group bên trong__


Tạo file `ex_nested_subject_spec.rb` như sau:
```
RSpec.describe Array do
  subject { [1, 2, 3] }

  describe "has some elements" do
    it "which are the prescribed elements" do
      expect(subject).to eq([1, 2, 3])
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/ex_nested_subject_spec.rb -fdoc     

Array
  has some elements
    which are the prescribed elements

Finished in 0.00137 seconds (files took 0.21984 seconds to load)
1 example, 0 failures
```

__3. Về memoized__

Tạo file `memoized_subject_spec.rb` như sau:
```
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
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/memoized_subject_spec.rb -fdoc   

Array
  is memoized across calls (i.e. the block is invoked once)
  is not memoized across examples

Finished in 0.01046 seconds (files took 0.20323 seconds to load)
2 examples, 0 failures
```

__4. `subject` available trong `before`__

Tạo file `before_hook_subject_spec.rb` như sau:
```
RSpec.describe Array, "with some elements" do
  subject { [] }

  before { subject.push(1, 2, 3) }

  it "has the prescribed elements" do
    expect(subject).to eq([1, 2, 3])
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/before_hook_subject_spec.rb      
.

Finished in 0.00209 seconds (files took 0.18129 seconds to load)
1 example, 0 failures
```

__5. Sử dụng `subject!` để đựợc gọi trước__

Tạo file `subject_bang_spec.rb` như sau:
```
RSpec.describe "eager loading with subject!" do
  subject! { element_list.push(99) }

  let(:element_list) { [1, 2, 3] }

  it "calls the definition block before the example" do
    element_list.push(5)
    expect(element_list).to eq([1, 2, 3, 99, 5])
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/subject/subject_bang_spec.rb -fdoc   

eager loading with subject!
  calls the definition block before the example

Finished in 0.00281 seconds (files took 0.20446 seconds to load)
1 example, 0 failures
```

__6. Define name cho subject__

Trong một vài trường hợp, ta có thể define name cho subject bằng cách gọi `subject(:_custom_name)` hoặc `subject(:_custom_name)`

Ví dụ thì chắc không cần :)

# One-liner syntax
Rspec hỗ trợ cú pháp trên một dòng để mô tả một expectation trên subject.

Ví dụ:
- Cách thông thường:
```
RSpec.describe Array do # example group 1 - EG1
  it 'should be empty when first created' do # example
    expect(subject).to be_empty #subject của EG1
  end
end
```
- Phong cách một dòng:
```
RSpec.describe Array do
  it { is_expected.to be_empty }
end
```

Ngoài `is_expected` chúng ta có thể sử dụng với `should` như:
```
RSpec.describe Array do
  it { should be_empty }
end
```
__Có một vài lưu ý:__
- Đây là tính năng chỉ khả dụng khi sử dụng gem rspec-expectations
- Những examples sử dụng phong cách one-liner syntax không thể gọi trực tiếp từ command line với option --example
- One-liner syntax chỉ hoạt động với non-block expectations (ví dụ: expect(obj)) và sẽ không hoạt động với block expectations (ví dụ: expect{ object })

_Với cách viết này sẽ ngắn gọn hơn rất nhiều và thường thấy trong khi viết rspec cho model ở trong rails._
