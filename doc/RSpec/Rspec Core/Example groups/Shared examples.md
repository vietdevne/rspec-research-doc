# Shared examples
Shared examples cho phép mô tả hành vi của các class hoặc module. Khi được khai báo, nội dung của một Shared examples sẽ được lưu trữ. Nó chỉ được thực hiện trong ngữ cảnh của
một nhóm ví dụ khác, nhóm này cung cấp bất kỳ ngữ cảnh nào mà nhóm được chia sẻ cần để
chạy. 
Ví dụ như có 2 controler là UsersController và PostsController, index của cả 2 đều trả về list tất cả các records (User.all và Post.all)

Sử dụng Shared examples bằng các cách sau:
```
include_examples "name"      # includes examples trong context hiện tại
it_behaves_like "name"       # include examples trong nested context.
it_should_behave_like "name" # như trên
```
__Lưu ý:__ 
- các file chứa Shared examples phải được load trước các file sử dụng chúng
- Khi đưa vào các tham số vào Shared examples giống nhau sẽ bị ghi đè và nó sẽ sử dụng tham số được khai báo cuối cùng

__Các ví dụ:__
