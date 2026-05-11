# Web audio/mp4 fix

Flutter Web khong doc duoc duong dan local that cua file nguoi dung chon.
Ban fix nay thay doi:

- FilePicker dung `withData: kIsWeb` de lay bytes tren web.
- SongModel co them `fileBytes` va `mimeType` cho file chon tu browser.
- AudioPlayerService neu co `fileBytes` se phat bang `Uri.dataFromBytes(...)`.
- Van giu cach phat bang `setFilePath(...)` cho Android/Desktop.
- Them `.mp4` vao danh sach allowedExtensions.

Luu y: mp4 chi phat duoc neu file co audio track va codec duoc browser ho tro.
