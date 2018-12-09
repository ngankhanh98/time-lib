# TIME
Đồ án 2 Kiến trúc máy tính &amp; hợp ngữ, bằng hợp ngữ MIPS

<b>1. Chức năng:</b> chương trình minh họa có giao diện menu như sau:
```
- Nhap ngay DAY:
- Nhap thang MONTH: 
- Nhap nam YEAR: 

----------Bạn hãy chọn 1 trong các thao tác dưới đây -----------
1. Xuất chuỗi TIME theo định dạng DD/MM/YYYY
2. Chuyển đổi chuỗi TIME thành một trong các định dạng sau:
A. MM/DD/YYYY
B. Month DD, YYYY
C. DD Month, YYYY
3. Cho biết ngày vừa nhập là ngày thứ mấy trong tuần:
4. Kiểm tra năm trong chuỗi TIME có phải là năm nhuậnkhông
5. Cho biết khoảng thời gian giữa chuỗi TIME_1 và TIME_2
6. Cho biết 2 năm nhuận gần nhất với năm trong chuỗi time (Chú ý: Hàm này phải xử dụng lại hàm ở câu 4.) 
7. Kiểm tra bộ dữ liệu đầu vào khi nhập, nếu dữ liệu không hợp lệ thì yêu cầu người dùng nhập lại. (Ví dụ 30/02/2012 hoặc a/1/2000 là không hợp lệ). Chú ý: năm
nhuận thì tháng 2 có 29 ngày, sinh viên cần kiểm tra kỹ.)
- Lựa chọn:
- Kết quả:
```

<b>2. Các hàm quan trọng </b><br/>
<b><code>char* Date(int day, int month, int year, char* TIME)</code></b><br/>
Xuất chuỗi TIME theo định dạng mặc định DD/MM/YYYY

<b><code>char* Convert(char* TIME, char type)</code></b><br/>
Chuyển đổi kiểu định dạng của chuỗi TIME

<b><code>int Day(char* TIME)</code></b><br/>
Lấy giá trị ngày từ chuỗi TIME

<b><code>int Month(char* TIME)</code></b><br/>
Lấy giá trị tháng từ chuỗi TIME

<b><code>int Year(char* TIME)</code></b><br/>
Lấy giá trị năm từ chuỗi TIME

<b><code>int LeapYear(char* TIME)</code></b><br/>
Kiểm tra năm nhuận

<b><code>int GetTime(char* TIME_1, char* TIME_2)</code></b><br/>
Tính khoảng thời gian cách biệt giữa giá trị năm của chuỗi TIME_1 và TIME_2

<b><code>char* Weekday(char* TIME)</code></b><br/>
Cho biết giá trị ngày trong chuỗi TIME là thứ mấy trong tuần
