# Offline Music Player - Lab 6

## 1. Mô tả dự án
Ứng dụng nghe nhạc offline bằng Flutter. Ứng dụng đọc nhạc từ bộ nhớ thiết bị hoặc chọn file nhạc thủ công, phát nhạc bằng `just_audio`, quản lý trạng thái bằng `provider`, lưu playlist và thiết lập bằng `shared_preferences`.

## 2. Chức năng đã làm
- Hiển thị danh sách bài hát offline trên thiết bị.
- Tìm kiếm bài hát theo tên, nghệ sĩ, album.
- Sắp xếp theo tên bài hát hoặc nghệ sĩ.
- Phát / tạm dừng / bài kế tiếp / bài trước.
- Thanh tua nhạc và hiển thị thời gian phát.
- Mini player ở cuối màn hình.
- Màn hình Now Playing đầy đủ.
- Shuffle và Repeat: off, repeat all, repeat one.
- Điều chỉnh âm lượng.
- Tạo playlist, đổi tên playlist, xóa playlist.
- Thêm / xóa bài hát khỏi playlist.
- Lưu playlist, shuffle/repeat/volume và bài hát phát gần nhất.
- Xử lý quyền truy cập audio/storage.
- Hỗ trợ chọn file nhạc bằng File Picker để test nhanh trên thiết bị/emulator.

## 3. Công nghệ sử dụng
- Flutter / Dart
- just_audio
- provider
- on_audio_query
- permission_handler
- shared_preferences
- file_picker
- audio_session
- rxdart

## 4. Cách chạy project
```bash
flutter pub get
flutter run
```

Nếu bạn chưa có project Flutter, tạo project trước:
```bash
flutter create offline_music_player
cd offline_music_player
```
Sau đó copy toàn bộ các thư mục/file trong gói này vào project vừa tạo.

## 5. Cấu hình Android
Mở file `android/app/src/main/AndroidManifest.xml` và thêm các quyền sau bên ngoài thẻ `<application>`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

Nếu dùng Android 13 trở lên, quyền quan trọng nhất là `READ_MEDIA_AUDIO`.

## 6. Cách thêm nhạc để test
Có 2 cách:

### Cách 1: Dùng nhạc trên điện thoại
Copy file `.mp3`, `.m4a`, `.wav`, `.flac` vào thiết bị thật, sau đó mở app và cấp quyền.

### Cách 2: Chọn file thủ công
Bấm nút **Import** trong app và chọn file audio từ máy.

Nếu thêm sample music vào thư mục `assets/audio/sample_songs/`, cần đảm bảo file có giấy phép hợp lệ và ghi nguồn trong `MUSIC_CREDITS.md`.

## 7. Screenshots cần chụp khi nộp
Tạo thư mục `screenshots/` và lưu các ảnh:
- Home screen với danh sách bài hát.
- Now Playing screen.
- Mini player.
- Playlist screen.
- Search screen hoặc trạng thái search trong Home.
- Settings screen.
- Permission dialog.

## 8. Hạn chế hiện tại
- Album art đang hiển thị placeholder để giữ code gọn và dễ chạy.
- Background notification nâng cao bằng `audio_service` chưa triển khai đầy đủ.
- Equalizer, lyrics, visualizer là phần bonus chưa làm.

## 9. Hướng phát triển
- Thêm notification controls bằng `audio_service`.
- Trích xuất album artwork bằng `QueryArtworkWidget`.
- Thêm sleep timer.
- Thêm lyrics.
- Thêm audio visualizer.
- Thêm dynamic theme theo màu album art.

## 10. Gợi ý comment khi upload E-learning
Audio formats tested: MP3, M4A.  
Device tested on: Android device / emulator.  
Extra features implemented: playlist, search, shuffle, repeat, volume, file picker import.  
Challenges faced: permission handling on Android 13+, missing metadata, empty music library handling.
