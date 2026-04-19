# Máy Tính Nâng Cao Trên Thiết Bị Di Động

<div align="center">

# 🧮 Advanced Calculator
**Ứng dụng máy tính đa chế độ được xây dựng bằng Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev/)
[![Provider](https://img.shields.io/badge/Quản%20lý%20trạng%20thái-Provider-8A2BE2)](https://pub.dev/packages/provider)
[![SharedPreferences](https://img.shields.io/badge/Lưu%20dữ%20liệu-SharedPreferences-4CAF50)](https://pub.dev/packages/shared_preferences)
[![math_expressions](https://img.shields.io/badge/Phân%20tích%20biểu%20thức-math__expressions-orange)](https://pub.dev/packages/math_expressions)

**Bài thực hành Chương 3 – Advanced Mobile Calculator**

</div>

---

## 📌 Giới thiệu dự án

Đây là dự án **ứng dụng máy tính nâng cao** được phát triển bằng **Flutter** trong bài thực hành Chương 3.  
Ứng dụng không chỉ dừng ở máy tính cơ bản mà còn hướng tới một sản phẩm có:

- Nhiều chế độ tính toán
- Hàm khoa học
- Phân tích biểu thức có ưu tiên toán tử
- Lưu lịch sử tính toán
- Chuyển đổi giao diện sáng/tối
- Lưu thiết lập người dùng
- Giao diện co giãn theo kích thước màn hình
- Kiến trúc rõ ràng theo `Provider`

Mục tiêu của dự án là xây dựng một ứng dụng có **cấu trúc sạch**, **dễ mở rộng**, **trải nghiệm sử dụng tốt**, và gần với ứng dụng thực tế.

---

## 🎯 Mục tiêu

Dự án này được thực hiện để rèn luyện và thể hiện các nội dung sau:

- Thiết kế giao diện Flutter ở mức nâng cao
- Xử lý và đánh giá biểu thức toán học
- Quản lý trạng thái bằng `Provider`
- Lưu dữ liệu cục bộ bằng `SharedPreferences`
- Thiết kế giao diện responsive
- Tổ chức dự án theo hướng widget tái sử dụng
- Xây dựng máy tính khoa học và khung cho programmer mode
- Chuẩn bị chiến lược kiểm thử cho logic và giao diện

---

## ✨ Tính năng chính

### 1. Máy tính nhiều chế độ

Ứng dụng hỗ trợ 3 chế độ hoạt động:

#### Basic Mode
- Các phép toán cơ bản: cộng, trừ, nhân, chia
- Bố cục nút 4×5 rõ ràng, dễ thao tác
- Phù hợp cho tính toán nhanh hằng ngày

#### Scientific Mode
- Hàm lượng giác: `sin`, `cos`, `tan`
- Hàm logarit: `ln`, `log`
- Lũy thừa: `x²`, `x^y`
- Hằng số: `π`
- Hỗ trợ ngoặc và nhập biểu thức nâng cao
- Hỗ trợ chuyển đổi góc `DEG/RAD`

#### Programmer Mode
Kiến trúc đã được chuẩn bị để mở rộng các tính năng:
- Chuyển đổi hệ: nhị phân, bát phân, thập phân, thập lục phân
- Phép toán bitwise: `AND`, `OR`, `XOR`, `NOT`
- Dịch bit: `<<`, `>>`

---

### 2. Phân tích biểu thức toán học

Ứng dụng hỗ trợ đánh giá biểu thức với các khả năng:

- Ưu tiên toán tử theo **PEMDAS**
- Hỗ trợ ngoặc
- Hỗ trợ nhân ngầm
- Hỗ trợ hằng số và ký hiệu toán học
- Báo lỗi khi biểu thức không hợp lệ

Ví dụ các biểu thức có thể hỗ trợ:

```text
(5 + 3) × 2 - 4 ÷ 2
sin(45)
2 × π × √9
```

---

### 3. Giao diện responsive

Giao diện được thiết kế để tự co giãn theo kích thước màn hình:

- Hiển thị tốt trên điện thoại
- Khi chạy trên màn hình rộng, máy tính được căn giữa
- Kích thước nút thay đổi theo không gian hiển thị
- Khu vực hiển thị kết quả tự điều chỉnh cỡ chữ
- Bố cục khác nhau được hỗ trợ cho từng chế độ

---

### 4. Khu vực hiển thị thông tin

Phần display area của ứng dụng hỗ trợ:

- Biểu thức hiện tại
- Kết quả hiện tại
- Kết quả trước đó
- Vùng hiển thị lỗi
- Nhãn chế độ đang dùng
- Chỉ báo `DEG/RAD`
- Chỉ báo bộ nhớ `M`

---

### 5. Chức năng bộ nhớ

Scientific mode hỗ trợ các thao tác bộ nhớ:

- `M+`
- `M-`
- `MR`
- `MC`

Các chức năng này giúp người dùng lưu tạm và gọi lại giá trị trong quá trình tính toán.

---

### 6. Theme và cài đặt

Kiến trúc của ứng dụng hỗ trợ mở rộng cho:

- Giao diện sáng
- Giao diện tối
- Giao diện theo hệ thống
- Chỉnh số chữ số thập phân
- Chuyển đổi `DEG/RAD`
- Thiết lập kích thước lịch sử
- Lưu thiết lập người dùng

---

### 7. Lịch sử tính toán

Ứng dụng được thiết kế để hỗ trợ:

- Lưu các phép tính trước đó
- Chọn lại biểu thức cũ để dùng tiếp
- Xóa toàn bộ lịch sử
- Lưu lịch sử bằng bộ nhớ cục bộ

---

## 🧱 Kiến trúc dự án

Dự án sử dụng kiến trúc phân lớp để tách rõ trách nhiệm giữa giao diện, trạng thái, logic và lưu trữ dữ liệu.

### Các lớp chính

- **Models**  
  Khai báo cấu trúc dữ liệu

- **Providers**  
  Quản lý trạng thái và cập nhật UI

- **Screens**  
  Đại diện cho các màn hình chính của ứng dụng

- **Widgets**  
  Các thành phần giao diện tái sử dụng

- **Utils**  
  Chứa logic thuần và các hàm xử lý biểu thức

- **Services**  
  Giao tiếp với lưu trữ cục bộ

---

## 🗂️ Cấu trúc thư mục

```text
lib/
├── main.dart
├── models/
│   ├── calculation_history.dart
│   ├── calculator_mode.dart
│   └── calculator_settings.dart
├── providers/
│   ├── calculator_provider.dart
│   ├── theme_provider.dart
│   └── history_provider.dart
├── screens/
│   ├── calculator_screen.dart
│   ├── history_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── display_area.dart
│   ├── button_grid.dart
│   ├── calculator_button.dart
│   └── mode_selector.dart
├── utils/
│   ├── calculator_logic.dart
│   ├── expression_parser.dart
│   └── constants.dart
└── services/
    └── storage_service.dart
```

---

## 🔄 Luồng quản lý trạng thái

Ứng dụng sử dụng **Provider** để quản lý trạng thái.

### Các provider chính

#### `CalculatorProvider`
Chịu trách nhiệm:

- Biểu thức hiện tại
- Kết quả hiện tại
- Kết quả trước đó
- Chế độ đang dùng
- Trạng thái `DEG/RAD`
- Giá trị bộ nhớ
- Xử lý thao tác bấm nút
- Thực hiện tính toán

#### `ThemeProvider`
Chịu trách nhiệm:

- Chọn light / dark / system theme
- Lưu theme người dùng đã chọn
- Cập nhật giao diện toàn app

#### `HistoryProvider`
Chịu trách nhiệm:

- Thêm lịch sử phép tính
- Đọc lịch sử đã lưu
- Xóa lịch sử
- Chuẩn bị dữ liệu để hiển thị lên UI

---

## 🧠 Thiết kế logic chính

### 1. Xử lý đầu vào
Tất cả thao tác bấm nút được xử lý tập trung trong `CalculatorProvider`.

Bao gồm:

- Phân loại nút bấm
- Cập nhật biểu thức
- Gọi hàm tính toán
- Thực hiện các lệnh memory
- Chuyển mode
- Xử lý xóa toàn bộ / xóa từng ký tự

---

### 2. Phân tích và tính biểu thức
Phần phân tích biểu thức được tách khỏi UI trong `expression_parser.dart`.

Nhiệm vụ:

- Chuẩn hóa ký hiệu như `×`, `÷`, `π`, `√`
- Xử lý định dạng biểu thức
- Hỗ trợ hàm khoa học
- Chuyển đổi góc khi dùng `DEG/RAD`
- Trả về kết quả số
- Bắt lỗi khi biểu thức không hợp lệ

---

### 3. Định dạng kết quả
`calculator_logic.dart` chịu trách nhiệm:

- Nối chuỗi nhập liệu an toàn
- Tránh nhập trùng dấu chấm thập phân
- Xóa ký tự cuối
- Định dạng kết quả đầu ra
- Xử lý đổi dấu `±`

---

## 🖼️ Điểm nổi bật trong thiết kế giao diện

### Mục tiêu thiết kế
- Gọn
- Dễ đọc
- Nhất quán
- Responsive
- Ưu tiên trải nghiệm trên thiết bị di động

### Quyết định thiết kế
- Nút bấm bo góc mềm
- Phân màu rõ giữa số, thao tác và toán tử
- Khu vực hiển thị được ưu tiên không gian
- Chuyển mode bằng segmented button
- Căn chỉnh dễ nhìn và đồng đều
- Hệ thống cỡ chữ có phân cấp rõ ràng

### Chiến lược responsive
- Giới hạn chiều rộng calculator trên màn hình lớn
- Nút thay đổi theo không gian còn lại
- Cỡ chữ ở display tự co giãn
- Điều chỉnh flex khác nhau khi chiều cao màn hình thấp

---

## 📷 Ảnh chụp màn hình

> Hãy lưu ảnh vào thư mục `screenshots/` và cập nhật lại tên file nếu cần.

### Chế độ cơ bản
![Basic Mode](screenshots/basic_mode.png)

### Chế độ khoa học
![Scientific Mode](screenshots/scientific_mode.png)

### Chế độ lập trình
![Programmer Mode](screenshots/programmer_mode.png)

### Màn hình cài đặt
![Settings](screenshots/settings_screen.png)

### Màn hình lịch sử
![History](screenshots/history_screen.png)

---

## ⚙️ Hướng dẫn cài đặt

### 1. Clone repository

```bash
git clone https://github.com/your-username/flutter_advanced_calculator_your_name.git
cd flutter_advanced_calculator_your_name
```

### 2. Cài dependencies

```bash
flutter pub get
```

### 3. Chạy dự án

```bash
flutter run
```

---

## 📦 Thư viện sử dụng

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  math_expressions: ^2.4.0
  intl: ^0.18.1
```

### Dev dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
```

---

## 🧪 Chiến lược kiểm thử

Dự án được thiết kế để hỗ trợ cả **unit test** và **integration test**.

### Unit test
Nên kiểm thử các phần:

- `calculator_logic.dart`
- `expression_parser.dart`
- Các thao tác memory
- Logic chuyển mode
- Logic định dạng kết quả

### Integration test
Nên kiểm thử các luồng:

- Chuỗi thao tác bấm nút
- Chuyển đổi qua lại giữa các mode
- Lưu và tải lịch sử
- Ghi nhớ theme
- Chuyển `DEG/RAD`
- Các phép tính khoa học

---

## ✅ Bộ test gợi ý

### Số học cơ bản
- `(5 + 3) × 2 - 4 ÷ 2 = 14`

### Lượng giác
- `sin(45°) + cos(45°) ≈ 1.414`

### Bộ nhớ
- `5 M+ 3 M+ MR = 8`

### Tính chuỗi
- `5 + 3 = + 2 = + 1 = 11`

### Ngoặc lồng nhau
- `((2 + 3) × (4 - 1)) ÷ 5 = 3`

### Khoa học kết hợp
- `2 × π × √9 ≈ 18.85`

### Programmer mode
- `0xFF AND 0x0F = 0x0F`

---

## 📚 Tài liệu nên có trong repository

```text
README.md
docs/
├── ARCHITECTURE.md
└── TESTING.md
screenshots/
test/
lib/
pubspec.yaml
```

Tài liệu nên bổ sung:

- `ARCHITECTURE.md`  
  Giải thích cấu trúc thư mục, luồng provider, trách nhiệm từng lớp

- `TESTING.md`  
  Mô tả test case, cách chạy test, đầu ra mong đợi

---

## 🚧 Hạn chế hiện tại

Ở giai đoạn hiện tại, một số hạn chế có thể còn tồn tại:

- Programmer mode có thể vẫn đang trong quá trình hoàn thiện
- Một số hàm khoa học nâng cao cần kiểm thử thêm
- Gesture support có thể chưa đầy đủ
- Một số animation chưa được hoàn thiện ở mọi màn hình
- Độ phủ test cần cải thiện thêm trước khi nộp cuối

---

## 🚀 Hướng phát triển tiếp theo

Các hướng mở rộng trong tương lai:

- Xuất lịch sử ra CSV hoặc PDF
- Nhập biểu thức bằng giọng nói
- Vẽ đồ thị hàm số
- Tạo theme tùy chỉnh
- Hoàn thiện đầy đủ programmer mode
- Mở rộng bộ phím khoa học
- Thêm hiệu ứng chuyển động mượt hơn
- Tối ưu giao diện cho tablet và landscape mode

---

## 📖 Danh sách kiểm tra trước khi nộp

Trước khi nộp bài, cần đảm bảo:

- [ ] Có đủ 3 chế độ tính toán
- [ ] Hàm khoa học hoạt động đúng
- [ ] Parser xử lý đúng ưu tiên toán tử
- [ ] Có lưu lịch sử
- [ ] Chuyển theme hoạt động
- [ ] Có màn hình settings
- [ ] Có unit test với độ phủ tốt
- [ ] README có ảnh minh họa
- [ ] Kiến trúc rõ ràng
- [ ] Không có lỗi biên dịch hoặc cảnh báo nghiêm trọng

## 👩‍💻 Thông tin sinh viên

- **Họ và tên:** Lê Nguyễn Bảo Trân
- **MSSV:** 2224802010476

---
