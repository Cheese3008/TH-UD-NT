# Weather App - Testing Results

## 1. Thông tin kiểm thử

- **Project:** Weather App with API Integration
- **API sử dụng:** OpenWeatherMap
- **Cách quản lý API key:** `.env` với biến `OPENWEATHER_API_KEY`
- **Nền tảng test chính:** Chrome Web
- **Ngày test:** 28/04/2026
- **Người test:** Lê Nguyễn Bảo Trân
- **Trạng thái biên dịch:** `flutter analyze` không phát hiện lỗi

---

## 2. Kiểm tra API key và cấu hình môi trường

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Kiểm tra file `.env` tồn tại | File `.env` nằm ngang hàng với `pubspec.yaml` | File `.env` tồn tại trong thư mục gốc project | Pass |
| 2 | Kiểm tra biến API key | `.env` có biến `OPENWEATHER_API_KEY` | CMD trả về `OK - da co OPENWEATHER_API_KEY` | Pass |
| 3 | Kiểm tra app đọc API key | App đọc được key từ `flutter_dotenv` | Log hiển thị `Has OPENWEATHER_API_KEY: true` và key length = 32 | Pass |
| 4 | Kiểm tra bảo mật API key | API key thật không được đưa lên GitHub | `.env` được cấu hình trong `.gitignore`, `.env.example` giữ key mẫu | Pass |
| 5 | Kiểm tra app sau khi `flutter clean` | App vẫn chạy sau khi xóa build cache | App chạy lại bình thường sau `flutter clean` và `flutter pub get` | Pass |

---

## 3. API Integration Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Mở app lần đầu khi có mạng | App gọi API và hiển thị thời tiết mặc định | App hiển thị thời tiết Thành phố Hồ Chí Minh | Pass |
| 2 | Tìm kiếm `Ho Chi Minh City` | App hiển thị thời tiết Thành phố Hồ Chí Minh | App hiển thị đúng Thành phố Hồ Chí Minh, VN | Pass |
| 3 | Tìm kiếm `Ha Noi` | App hiển thị thời tiết Hà Nội | App hiển thị đúng Hà Nội, VN | Pass |
| 4 | Tìm kiếm `Da Nang` | App hiển thị thời tiết Đà Nẵng | App hiển thị đúng Đà Nẵng | Pass |
| 5 | Tìm kiếm `Tokyo` | App hiển thị thời tiết Tokyo | App hiển thị đúng Tokyo, JP | Pass |
| 6 | API trả về dữ liệu current weather | App parse được nhiệt độ, mô tả, icon, độ ẩm, gió, áp suất | App hiển thị đầy đủ trên HomeScreen | Pass |
| 7 | API trả về dữ liệu forecast | App parse được danh sách forecast | App hiển thị được dự báo theo giờ và dự báo 5 ngày | Pass |
| 8 | Tìm kiếm city không tồn tại | App hiển thị thông báo lỗi và không crash | App không crash, có xử lý lỗi | Pass |

---

## 4. HomeScreen Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Hiển thị card thời tiết chính | Card hiển thị tên thành phố, quốc gia, ngày, icon, nhiệt độ, mô tả | Card hiển thị đầy đủ | Pass |
| 2 | Hiển thị chi tiết thời tiết | App hiển thị độ ẩm, gió, áp suất, tầm nhìn, mây, min/max | Các thông tin chi tiết hiển thị đúng | Pass |
| 3 | Hiển thị dự báo gần nhất | App hiển thị danh sách forecast ngang | Danh sách forecast ngang hiển thị đúng | Pass |
| 4 | Tìm city trực tiếp trên HomeScreen | Nhập city và bấm Tìm thì dữ liệu đổi theo city mới | App tìm và cập nhật dữ liệu thành công | Pass |
| 5 | Nút refresh trên AppBar | App gọi lại API hoặc hiển thị cache khi offline | Hoạt động đúng | Pass |
| 6 | Nút GPS trên AppBar | App yêu cầu quyền vị trí hoặc lấy thời tiết theo vị trí hiện tại | Có nút GPS và xử lý qua `LocationService` | Pass |
| 7 | Nút Search trên AppBar | Mở SearchScreen | Hoạt động đúng | Pass |
| 8 | Nút Forecast trên AppBar | Mở ForecastScreen | Hoạt động đúng | Pass |
| 9 | Nút Settings trên AppBar | Mở SettingsScreen | Hoạt động đúng | Pass |

---

## 5. Search Functionality Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Mở SearchScreen | App chuyển sang màn hình tìm kiếm thành phố | Màn hình `Tìm kiếm thành phố` hiển thị đúng | Pass |
| 2 | Nhập `Hà Nội` và bấm Tìm | App hiển thị thời tiết Hà Nội | App hiển thị card Hà Nội, VN | Pass |
| 3 | Nhập city hợp lệ khác | App hiển thị thời tiết city đó | App hiển thị đúng city được nhập | Pass |
| 4 | Nhập rỗng và bấm Tìm | App hiển thị cảnh báo nhập tên thành phố | App hiển thị SnackBar yêu cầu nhập tên thành phố | Pass |
| 5 | Hiển thị lịch sử tìm kiếm | City đã tìm được lưu vào danh sách gần đây | App hiển thị Hà Nội, Đà Nẵng, Tokyo, Huế, Bạc Liêu, Thành phố Hồ Chí Minh | Pass |
| 6 | Bấm city trong lịch sử tìm kiếm | App tìm lại city đã chọn | App gọi lại dữ liệu và cập nhật card kết quả | Pass |
| 7 | Thêm city vào yêu thích | City xuất hiện trong mục Thành phố yêu thích | App thêm được Đà Nẵng và Tokyo vào danh sách yêu thích | Pass |
| 8 | Xóa city khỏi yêu thích | City bị xóa khỏi danh sách yêu thích | Bấm lại icon trái tim thì city được xóa | Pass |
| 9 | Quay lại HomeScreen sau khi tìm | HomeScreen hiển thị city vừa tìm | HomeScreen cập nhật theo city mới | Pass |

---

## 6. Forecast Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Mở ForecastScreen | App hiển thị màn hình dự báo thời tiết | ForecastScreen mở thành công | Pass |
| 2 | Kiểm tra phần header | Header hiển thị city hiện tại và thời gian cập nhật | Hiển thị Thành phố Hồ Chí Minh, VN và thời gian cập nhật | Pass |
| 3 | Kiểm tra dự báo theo giờ | App hiển thị các mốc giờ forecast | App hiển thị các mốc 16:00, 19:00, 22:00, 01:00, 04:00, v.v. | Pass |
| 4 | Kiểm tra nhiệt độ theo giờ | Mỗi item forecast có nhiệt độ | Nhiệt độ hiển thị đúng theo từng mốc giờ | Pass |
| 5 | Kiểm tra xác suất mưa | Forecast hiển thị phần trăm mưa nếu API có dữ liệu | App hiển thị 0%, 10%, 13% mưa tùy mốc giờ | Pass |
| 6 | Kiểm tra dự báo 5 ngày | App hiển thị danh sách dự báo theo ngày | App hiển thị mục `Dự báo 5 ngày` | Pass |
| 7 | Kiểm tra thông tin trong dự báo 5 ngày | Có min/max temperature, độ ẩm, gió, xác suất mưa | Các thông tin hiển thị trong từng card ngày | Pass |
| 8 | Bấm refresh trong ForecastScreen | App cập nhật lại dữ liệu forecast | Nút refresh hoạt động | Pass |
| 9 | Đổi đơn vị nhiệt độ sang °F | ForecastScreen hiển thị °F | ForecastScreen đổi sang °F thành công | Pass |

---

## 7. Settings Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Mở SettingsScreen | App hiển thị màn hình Cài đặt | Màn hình Cài đặt mở thành công | Pass |
| 2 | Đổi Celsius sang Fahrenheit | Nhiệt độ đổi từ °C sang °F | HomeScreen đổi sang °F | Pass |
| 3 | Kiểm tra ForecastScreen sau khi đổi °F | ForecastScreen cũng đổi sang °F | ForecastScreen hiển thị 94°F, 88°F, 101°F, v.v. | Pass |
| 4 | Đổi Fahrenheit sang Celsius | Nhiệt độ đổi lại từ °F sang °C | HomeScreen và ForecastScreen đổi lại °C | Pass |
| 5 | Đổi đơn vị gió sang km/h | Tốc độ gió hiển thị km/h | Setting được chọn và lưu | Pass |
| 6 | Đổi đơn vị gió sang mph | Tốc độ gió hiển thị mph | Setting được chọn và lưu | Pass |
| 7 | Đổi định dạng giờ 24h/12h | Forecast đổi định dạng giờ | Setting hoạt động qua `WeatherProvider` | Pass |
| 8 | Đổi ngôn ngữ vi/en | App lưu lựa chọn ngôn ngữ | Setting được lưu trong `SharedPreferences` | Pass |
| 9 | Đóng app và mở lại | Cài đặt vẫn được lưu | Setting vẫn được giữ nhờ `SharedPreferences` | Pass |

---

## 8. Offline Cache Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Tải dữ liệu khi có mạng | App lưu weather và forecast vào cache | App lưu được dữ liệu weather/forecast gần nhất | Pass |
| 2 | Tìm Hà Nội khi có mạng | App tải Hà Nội và lưu cache | App hiển thị Hà Nội và lưu cache | Pass |
| 3 | Chuyển Chrome DevTools sang Offline | App không gọi được API mới | DevTools được đặt ở chế độ Offline và Disable cache | Pass |
| 4 | Bấm refresh khi offline | App không crash và hiển thị dữ liệu cache | App hiển thị banner `Đang hiển thị dữ liệu cache` | Pass |
| 5 | Kiểm tra nội dung cache khi offline | App giữ dữ liệu gần nhất | App vẫn hiển thị dữ liệu đã lưu thay vì màn hình trắng | Pass |
| 6 | Tìm city mới `Reykjavik` khi offline | App không tải được city mới và dùng cache gần nhất | App báo `Thiết bị đang offline. Đang hiển thị dữ liệu đã lưu.` và vẫn giữ dữ liệu Tokyo, JP | Pass |
| 7 | Kiểm tra Network khi offline | Request API không được gửi thành công | Network đang ở chế độ Offline, không có request thành công tới API | Pass |
| 8 | Bật mạng lại bằng `No throttling` | App có thể gọi API trở lại | Sau khi bật lại mạng và refresh, app tải dữ liệu bình thường | Pass |
| 9 | Banner cache sau khi online | Banner cache/offline biến mất khi tải dữ liệu mới thành công | App trở lại trạng thái online sau refresh | Pass |

---

## 9. UI Responsiveness Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Chạy app trên Chrome màn hình lớn | UI hiển thị đầy đủ | HomeScreen hiển thị đầy đủ card, details, forecast | Pass |
| 2 | Thu nhỏ cửa sổ trình duyệt | UI không bị RenderFlex overflow | Đã sửa `_SearchCityBox`, không còn lỗi overflow | Pass |
| 3 | Kéo xuống HomeScreen | Nội dung scroll được | HomeScreen scroll được | Pass |
| 4 | Kéo ngang forecast trên HomeScreen | Danh sách forecast cuộn ngang được | Forecast preview cuộn ngang được | Pass |
| 5 | Kéo ngang dự báo theo giờ trong ForecastScreen | Danh sách forecast theo giờ cuộn ngang được | Hoạt động đúng | Pass |
| 6 | Kiểm tra SearchScreen trên màn hình rộng | SearchScreen hiển thị rõ ràng, không vỡ layout | Hoạt động đúng | Pass |
| 7 | Kiểm tra SettingsScreen | Các option card hiển thị rõ, dễ chọn | Hoạt động đúng | Pass |

---

## 10. Loading State Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | App tải dữ liệu lần đầu | Loading UI xuất hiện trước khi có dữ liệu | LoadingShimmer được cấu hình | Pass |
| 2 | Tìm kiếm city | Nút Tìm chuyển trạng thái loading | Nút Tìm có trạng thái loading khi provider đang tải | Pass |
| 3 | Refresh dữ liệu | App xử lý loading, không khóa UI bất thường | Refresh hoạt động ổn định | Pass |

---

## 11. Error Handling Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Nhập city sai | App hiển thị lỗi, không crash | App xử lý lỗi và không crash | Pass |
| 2 | Nhập rỗng | App cảnh báo người dùng | App hiển thị SnackBar | Pass |
| 3 | Mất mạng khi refresh | App dùng cache hoặc báo lỗi rõ ràng | App hiển thị banner offline/cache | Pass |
| 4 | Mất mạng khi tìm city mới | App không crash, không mất dữ liệu cũ | App vẫn giữ cache gần nhất | Pass |
| 5 | API key chưa cấu hình | App báo lỗi cấu hình API key | Đã từng phát hiện và sửa lỗi `.env`; sau khi sửa app đọc key thành công | Pass |
| 6 | RenderFlex overflow | UI không bị overflow sau khi sửa responsive | Đã sửa `_SearchCityBox` bằng `LayoutBuilder` | Pass |

---

## 12. Code Quality Testing

| STT | Test case | Kết quả mong đợi | Kết quả thực tế | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Chạy `dart format lib` | Code được format theo chuẩn Dart | Format thành công | Pass |
| 2 | Chạy `flutter analyze` | Không có lỗi phân tích tĩnh | `No issues found!` | Pass |
| 3 | Kiểm tra cấu trúc thư mục | Project chia models, services, providers, screens, widgets, utils, config | Cấu trúc đúng yêu cầu Lab 4 | Pass |
| 4 | Kiểm tra `.env` | API key không hard-code trong code | API key được đọc từ `.env` | Pass |
| 5 | Kiểm tra `.env.example` | Có file mẫu cho API key | `.env.example` đã được tạo | Pass |
| 6 | Kiểm tra `.gitignore` | `.env` không được commit | `.env` đã được đưa vào `.gitignore` | Pass |

---

## 13. Kết luận kiểm thử

Ứng dụng đã hoàn thành các chức năng chính của Lab 4 gồm:

- Hiển thị thời tiết hiện tại.
- Gọi API OpenWeatherMap.
- Parse dữ liệu JSON sang model.
- Tìm kiếm thời tiết theo tên thành phố.
- Hiển thị lịch sử tìm kiếm.
- Quản lý thành phố yêu thích.
- Hiển thị dự báo theo giờ.
- Hiển thị dự báo 5 ngày.
- Hiển thị chi tiết thời tiết.
- Hỗ trợ đổi đơn vị nhiệt độ.
- Hỗ trợ đổi đơn vị tốc độ gió.
- Hỗ trợ đổi định dạng giờ.
- Lưu cài đặt bằng `SharedPreferences`.
- Hỗ trợ cache offline.
- Hiển thị dữ liệu đã lưu khi thiết bị mất mạng.
- Xử lý lỗi API, lỗi mất mạng và lỗi nhập liệu.
- Giao diện responsive, không còn lỗi overflow sau khi sửa `_SearchCityBox`.

Kết quả kiểm thử cho thấy app hoạt động ổn định trên Chrome Web, không có lỗi biên dịch và `flutter analyze` không phát hiện lỗi.
