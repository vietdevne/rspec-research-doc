# Getting started
## Prerequisites
- Phiên bản Ruby 1.8.7 hoặc cao hơn (khuyên dùng 2.0+)
## Install
```
gem install rspec
```

Sau khi chạy lệnh trên sẽ được cài đặt 5 gem sau:
- rspec
- rspec-core
- rspec-expectations
- rspec-mocks
- rspec-support

Sau đó có thể sử dụng được các câu lệnh về rspec, gõ `rspec --help` để xem các lựa chọn.

## Getting started
Bắt đầu bằng một ví dụ rất đơn giản thể hiện một số hành vi mong muốn cơ bản:
```
# game_spec.rb

RSpec.describe Game do
  describe "#score" do
    it "returns 0 for an all gutter game" do
      game = Game.new
      20.times { game.roll(0) }
      expect(game.score).to eq(0)
    end
  end
end
```
nó sẽ lỗi như sau:
```
➜  rspec-research-doc git:(main) ✗ rspec spec/game_spec.rb 

An error occurred while loading ./spec/game_spec.rb.
Failure/Error:
  RSpec.describe Game do
    describe "#score" do
      it "returns 0 for an all gutter game" do
        game = Game.new
        20.times { game.roll(0) }
        expect(game.score).to eq(0)
      end
    end
  end

NameError:
  uninitialized constant Game
# ./spec/game_spec.rb:1:in `<top (required)>'
No examples found.


Finished in 0.00891 seconds (files took 0.39384 seconds to load)
0 examples, 0 failures, 1 error occurred outside of examples
```
Ta phải khởi tại class Game để pass unit test trên:
```
# game.rb

class Game
  def roll(pins)
  end

  def score
    0
  end
end
```

Chạy rspec và đắm mình trong niềm vui có màu xanh lá cây:
```
➜  rspec-research-doc git:(main) ✗ rspec spec/game_spec.rb
.

Finished in 0.0077 seconds (files took 0.33124 seconds to load)
1 example, 0 failures
```
