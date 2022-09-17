# `around` hooks

Như cái tên, around chạy trước và sau 1 example, điều này sẽ giúp clean hơn việc dùng `before` và `after`.
### Note:
- Không thể chia sẻ instance variable với các example
- `around` sẽ chạy trước bất kỳ một `before` nào và tương tự cũng sẽ chạy sau bất kỳ một `after` nào.

### Dưới đây là một vài ví dụ về cách sử dụng `around`:

__1. Sử dụng example như một proc với truyền vào `around`:__

Tạo file `example_spec.rb` như sau:
```
class Database
  def self.transaction
    puts "open transaction"
    yield
    puts "close transaction"
  end
end

RSpec.describe "around filter" do
  around(:example) do |example|
    Database.transaction(&example)
  end

  it "gets run in order" do
    puts "run the example"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/example_spec.rb -fdoc

around filter
open transaction
run the example
close transaction
  gets run in order

Finished in 0.00107 seconds (files took 0.09591 seconds to load)
1 example, 0 failures
```

__2. Gọi example bằng các sử dụng `run()`:__

Tạo file `run_example_spec.rb` như sau:
```
RSpec.describe "around hook" do
  around(:example) do |example|
    puts "around example before"
    example.run
    puts "around example after"
  end

  it "gets run in order" do
    puts "in the example"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/run_example_spec.rb -fdoc

around hook
around example before
in the example
around example after
  gets run in order

Finished in 0.00111 seconds (files took 0.09721 seconds to load)
1 example, 0 failures
```

__3. `around` vẫn tiếp tục chạy ngay cả khi example raise exception__

Tạo file `err_example_spec.rb` như sau:
```
RSpec.describe "something" do
  around(:example) do |example|
    puts "around example setup"
    example.run
    puts "around example cleanup"
  end

  it "still executes the entire around hook" do
    fail "the example blows up"
  end
end
```

Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/err_example_spec.rb -fdoc

something
around example setup
around example cleanup
  still executes the entire around hook (FAILED - 1)

Failures:

  1) something still executes the entire around hook
     Failure/Error: fail "the example blows up"
     
     RuntimeError:
       the example blows up
     # ./spec/around/err_example_spec.rb:9:in `block (2 levels) in <top (required)>'
     # ./spec/around/err_example_spec.rb:4:in `block (2 levels) in <top (required)>'

Finished in 0.00113 seconds (files took 0.09931 seconds to load)
1 example, 1 failure
```

__4. Define một `global around`:__

Tạo file `global_example_spec.rb` như sau:
```
RSpec.configure do |c|
  c.around(:example) do |example|
    puts "around example before"
    example.run
    puts "around example after"
  end
end

RSpec.describe "around filter" do
  it "gets run in order" do
    puts "in the example"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/global_example_spec.rb -fdoc

around filter
around example before
in the example
around example after
  gets run in order

Finished in 0.00363 seconds (files took 0.10688 seconds to load)
1 example, 0 failures

```

__5. Kết hợp `before` và `after` với `around`:__

Tạo file `per_example_spec.rb` như sau:
```
RSpec.describe "around filter" do
  around(:example) do |example|
    puts "around example before"
    example.run
    puts "around example after"
  end

  before(:example) do
    puts "before example"
  end

  after(:example) do
    puts "after example"
  end

  it "gets run in order" do
    puts "in the example"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/per_example_spec.rb -fdoc   

around filter
around example before
before example
in the example
after example
around example after
  gets run in order

Finished in 0.00108 seconds (files took 0.09706 seconds to load)
1 example, 0 failures
```

__6. Context không được bao bọc bởi `around`__

Tạo file `not_wrap_example_spec.rb` như sau:
```
RSpec.describe "around filter" do
  around(:example) do |example|
    puts "around example before"
    example.run
    puts "around example after"
  end

  before(:context) do
    puts "before context"
  end

  after(:context) do
    puts "after context"
  end

  it "gets run in order" do
    puts "in the example"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/not_wrap_example_spec.rb -fdoc

around filter
before context
around example before
in the example
around example after
  gets run in order
after context

Finished in 0.00114 seconds (files took 0.09394 seconds to load)
1 example, 0 failures
```

==============================================================

Kết luận rút ra từ ví dụ 5 và 6:

```
around sẽ chạy trước mỗi before(:example), sau mỗi after(:example)
around sẽ chạy sau mỗi before(:context), trước mỗi after(:context)
```
==============================================================

__7. `around` với example đang pending:__

Tạo file `pending_example_spec.rb` như sau:
```
RSpec.describe "implicit pending example" do
  around(:example) do |example|
    example.run
  end

  it "should be detected as Not yet implemented"

  it "should be detected as pending" do
    pending
    fail
  end
end

```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/pending_example_spec.rb -fdoc

implicit pending example
  should be detected as Not yet implemented (PENDING: Not yet implemented)
  should be detected as pending (PENDING: No reason given)

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) implicit pending example should be detected as Not yet implemented
     # Not yet implemented
     # ./spec/around/pending_example_spec.rb:6

  2) implicit pending example should be detected as pending
     # No reason given
     Failure/Error: fail
     RuntimeError:
     # ./spec/around/pending_example_spec.rb:10:in `block (2 levels) in <top (required)>'
     # ./spec/around/pending_example_spec.rb:3:in `block (2 levels) in <top (required)>'

Finished in 0.00119 seconds (files took 0.09261 seconds to load)
2 examples, 0 failures, 2 pending
```

__8. Sử dụng nhiều around__

Tạo file `multiple_around_example_spec.rb` như sau:
```
RSpec.describe "if there are multiple around hooks in the same scope" do
  around(:example) do |example|
    puts "first around hook before"
    example.run
    puts "first around hook after"
  end

  around(:example) do |example|
    puts "second around hook before"
    example.run
    puts "second around hook after"
  end

  it "they should all be run" do
    puts "in the example"
    expect(1).to eq(1)
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/multiple_around_example_spec.rb -fdoc

if there are multiple around hooks in the same scope
first around hook before
second around hook before
in the example
second around hook after
first around hook after
  they should all be run

Finished in 0.00156 seconds (files took 0.09401 seconds to load)
1 example, 0 failures
```

Nhiều `around` hơn nữa:
```
RSpec.describe "if there are around hooks in an outer scope" do
  around(:example) do |example|
    puts "first outermost around hook before"
    example.run
    puts "first outermost around hook after"
  end

  around(:example) do |example|
    puts "second outermost around hook before"
    example.run
    puts "second outermost around hook after"
  end

  describe "outer scope" do
    around(:example) do |example|
      puts "first outer around hook before"
      example.run
      puts "first outer around hook after"
    end

    around(:example) do |example|
      puts "second outer around hook before"
      example.run
      puts "second outer around hook after"
    end

    describe "inner scope" do
      around(:example) do |example|
        puts "first inner around hook before"
        example.run
        puts "first inner around hook after"
      end

      around(:example) do |example|
        puts "second inner around hook before"
        example.run
        puts "second inner around hook after"
      end

      it "they should all be run" do
        puts "in the example"
      end
    end
  end
end
```

Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/around/multiple_around_example_spec.rb -fdoc

if there are around hooks in an outer scope
  outer scope
    inner scope
first outermost around hook before
second outermost around hook before
first outer around hook before
second outer around hook before
first inner around hook before
second inner around hook before
in the example
second inner around hook after
first inner around hook after
second outer around hook after
first outer around hook after
second outermost around hook after
first outermost around hook after
      they should all be run

Finished in 0.00125 seconds (files took 0.09804 seconds to load)
1 example, 0 failures
```
Có thể thấy thứ tự chạy của `around` từ ngoài vào trong.
