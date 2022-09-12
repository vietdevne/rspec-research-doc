# Cấu trúc cơ bản
RSpec là một DSL để tạo các example thực thi về cách code dự kiến ​​sẽ hoạt động, được tổ chức theo nhóm. Nó sử dụng các từ "describe" và "it" để chúng ta có thể diễn đạt các khái niệm giống như một cuộc trò chuyện:
```
"Describe an account when it is first opened."
"It has a balance of zero."
```
Method describe tạo một nhóm example. Có thể khai báo các nhóm lồng nhau bằng cách sử dụng các method describe hoặc context hoặc có thể khai báo các example bằng cách sử dụng các method `it` hoặc `specify`.

# Các trường hợp
## 1 group, 1 example:
Tạo 1 file `sample_spec.rb` như sau:
```
RSpec.describe "something" do
  it "does something" do
  end
end
```
Khi chạy `rspec spec/sample_spec.rb -fdoc` kết quả như sau:
```
➜  rspec-research-doc git:(main) ✗ rspec spec/sample_spec.rb -fdoc

something
  does something

Finished in 0.00092 seconds (files took 0.19167 seconds to load)
1 example, 0 failures
```
## Các example lồng nhau:
Tạo 1 file `nested_example_groups_spec.rb` như sau:
```
RSpec.describe "something" do
  context "in one context" do
    it "does one thing" do
    end
  end

  context "in another context" do
    it "does another thing" do
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(main) ✗ rspec spec/nested_example_groups_spec.rb -fdoc

something
  in one context
    does one thing
  in another context
    does another thing

Finished in 0.0009 seconds (files took 0.1157 seconds to load)
2 examples, 0 failures

```
