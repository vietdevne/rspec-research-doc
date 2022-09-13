# `before` & `after`
Sử dụng before và after hook để thực hiện một đoạn codes nào đó trước/sau khi chạy một example:
```
before(:example) # chạy trước mỗi example
before(:context) # chạy một lần duy nhất, trước tất cả examples trong một group

after(:example) # chạy sau mỗi example
after(:context) # chạy một lần duy nhất, sau tất cả examples trong một group
```
VD:
```
before(:context) 
# before(:context) run
it { expect(5).to be >= 3 }
it { expect("Welcome to RSpec").to match(/RSpec$/) }
it { expect(dog).to be_instance_of(Dog) }

before(:example)
# before(:example) run
it { expect(5).to be >= 3 }
# before(:example) run
it { expect("Welcome to RSpec").to match(/RSpec$/) }
# before(:example) run
it { expect(dog).to be_instance_of(Dog) }
```

before và after block được gọi theo thứ tự sau:
```
before :suite
before :context
before :example
after  :example
after  :context
after  :suite
```

__Note:__

- Setting một instance variable không hỗ trợ trong before(:suite)
- Mocks chỉ hỗ trợ trong before(:example)
- :example và :context scope tương đương với :each và :all
- Chúng ta chỉ cần viết before/after thôi, không cần before(:each)/after(:each)


## Cách dùng:
__1. Define `before(:example)`__

Tạo file `before_example_spec.rb` như sau:
```
require "rspec/expectations"

class Thing
  def widgets
    @widgets ||= []
  end
end

RSpec.describe Thing do
  before(:example) do
    @thing = Thing.new
  end

  describe "initialized in before(:example)" do
    it "has 0 widgets" do
      expect(@thing.widgets.count).to eq(0)
    end

    it "can accept new widgets" do
      @thing.widgets << Object.new
    end

    it "does not share state across examples" do
      expect(@thing.widgets.count).to eq(0)
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/before_example_spec.rb -fdoc       

Thing
  initialized in before(:example)
    has 0 widgets
    can accept new widgets
    does not share state across examples

Finished in 0.00147 seconds (files took 0.15213 seconds to load)
3 examples, 0 failures
```

__2. Define `before(:context)` block trong group__
Tạo file `before_context_spec.rb` như sau:
```
require "rspec/expectations"

class Thing
  def widgets
    @widgets ||= []
  end
end

RSpec.describe Thing do
  before(:context) do
    @thing = Thing.new
  end

  describe "initialized in before(:context)" do
    it "has 0 widgets" do
      expect(@thing.widgets.count).to eq(0)
    end

    it "can accept new widgets" do
      @thing.widgets << Object.new
    end

    it "shares state across examples" do
      expect(@thing.widgets.count).to eq(1)
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/before_context_spec.rb -fdoc    

Thing
  initialized in before(:context)
    has 0 widgets
    can accept new widgets
    shares state across examples

Finished in 0.00117 seconds (files took 0.13484 seconds to load)
3 examples, 0 failures


➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/before_context_spec.rb:15 -fdoc
Run options: include {:locations=>{"./spec/before_context_spec.rb"=>[15]}}

Thing
  initialized in before(:context)
    has 0 widgets

Finished in 0.00071 seconds (files took 0.12007 seconds to load)
1 example, 0 failures

```
__3. Trường hợp lỗi `before (: context)`__
Tạo file `fail_before_context_spec.rb` như sau:
```
RSpec.describe "an error in before(:context)" do
  before(:context) do
    raise "oops"
  end

  it "fails this example" do
  end

  it "fails this example, too" do
  end

  after(:context) do
    puts "after context ran"
  end

  describe "nested group" do
    it "fails this third example" do
    end

    it "fails this fourth example" do
    end

    describe "yet another level deep" do
      it "fails this last example" do
      end
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/fail_before_context_spec.rb -fdoc 

an error in before(:context)
  fails this example (FAILED - 1)
  fails this example, too (FAILED - 2)
  nested group
    fails this third example (FAILED - 3)
    fails this fourth example (FAILED - 4)
    yet another level deep
      fails this last example (FAILED - 5)
after context ran
```
__4. Trường hợp lỗi `after(:context)`__
Tạo file `fail_after_context_spec.rb` như sau:
```
RSpec.describe "an error in after(:context)" do
  after(:context) do
    raise StandardError.new("Boom!")
  end

  it "passes this example" do
  end

  it "passes this example, too" do
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/fail_after_context_spec.rb -fdoc   

an error in after(:context)
  passes this example
  passes this example, too
  
An error occurred in an `after(:context)` hook.
Failure/Error: raise StandardError.new("Boom!")

StandardError:
  Boom!
# ./spec/fail_after_context_spec.rb:3:in `block (2 levels) in <top (required)>'

Finished in 0.01351 seconds (files took 0.10621 seconds to load)
2 examples, 0 failures, 1 error occurred outside of examples
```

__5. Trường hợp fail không ảnh hưởng tới hooks__
Tạo file `failure_in_example_spec.rb` như sau:
```
RSpec.describe "a failing example does not affect hooks" do
  before(:context) { puts "before context runs" }
  before(:example) { puts "before example runs" }
  after(:example) { puts "after example runs" }
  after(:context) { puts "after context runs" }

  it "fails the example but runs the hooks" do
    raise "An Error"
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/failure_in_example_spec.rb -fdoc  

a failing example does not affect hooks
before context runs
before example runs
after example runs
  fails the example but runs the hooks (FAILED - 1)
after context runs

Failures:

  1) a failing example does not affect hooks fails the example but runs the hooks
     Failure/Error: raise "An Error"
     
     RuntimeError:
       An Error
     # ./spec/failure_in_example_spec.rb:8:in `block (2 levels) in <top (required)>'

Finished in 0.00073 seconds (files took 0.10377 seconds to load)
1 example, 1 failure
```

__6. Define `before` và `after` trong config__
Tạo file `befores_in_configuration_spec.rb` như sau:
```
require "rspec/expectations"

RSpec.configure do |config|
  config.before(:example) do
    @before_example = "before example"
  end
  config.before(:context) do
    @before_context = "before context"
  end
end

RSpec.describe "stuff in before blocks" do
  describe "with :context" do
    it "should be available in the example" do
      expect(@before_context).to eq("before context")
    end
  end
  describe "with :example" do
    it "should be available in the example" do
      expect(@before_example).to eq("before example")
    end
  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/befores_in_configuration_spec.rb -fdoc

stuff in before blocks
  with :context
    should be available in the example
  with :example
    should be available in the example

Finished in 0.00107 seconds (files took 0.10255 seconds to load)
2 examples, 0 failures
```

__7. `before`/`after` chạy theo thứ tự__
Tạo file `ensure_block_order_spec.rb` như sau:
```
require "rspec/expectations"

RSpec.describe "before and after callbacks" do
  before(:context) do
    puts "before context"
  end

  before(:example) do
    puts "before example"
  end

  before do
    puts "also before example but by default"
  end

  after(:example) do
    puts "after example"
  end

  after do
    puts "also after example but by default"
  end

  after(:context) do
    puts "after context"
  end

  it "gets run in order" do

  end
end
```
Kết quả:
```
➜  rspec-research-doc git:(feature/rspec_core) ✗ rspec spec/ensure_block_order_spec.rb -fdoc        

before and after callbacks
before context
before example
also before example but by default
also after example but by default
after example
  gets run in order
after context

Finished in 0.00079 seconds (files took 0.10041 seconds to load)
1 example, 0 failures
```
