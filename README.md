# Professional Commerce System (Level 4 - App with RESTful API)

Dự án Flutter quản lý sản phẩm và giỏ hàng, áp dụng **Clean Architecture** kết hợp với quản lý trạng thái **GetX**, tích hợp kết nối **RESTful API** và lưu trữ dữ liệu cục bộ bằng **Hive**.

## Demo 
<p align="center">
  <video src="[https://github.com/user-attachments/assets/9cbb279e-8226-41c2-947f-fb01a2af2150](https://github.com/user-attachments/assets/7dda84ef-77de-4a7e-bc96-f8b25a3d7366)" width="400" controls></video>
</p>



---

## 🚀 Tính Năng Chính

*   **Quản lý sản phẩm (Catalog CRUD)**: 
    *   Tải danh sách sản phẩm từ RESTful API hỗ trợ phân trang (Pagination) và cuộn vô hạn (Infinite Scroll).
    *   Thêm mới, cập nhật thông tin và xóa sản phẩm trực tiếp từ giao diện.
*   **Giỏ hàng phản ứng (Reactive Cart)**:
    *   Thêm/xóa sản phẩm trực tiếp ngoài màn hình danh sách hoặc trong trang chi tiết.
    *   Tự động tính toán tổng số lượng và tổng giá trị đơn hàng theo thời gian thực.
*   **Lưu trữ cục bộ (Local Caching)**:
    *   Sử dụng **Hive** để lưu trữ thông tin giỏ hàng (`ProductModel`), cấu hình cài đặt (`HiveSettings`) và mã đăng nhập (`HiveToken`).
    *   Tự động tải lại giỏ hàng cũ khi khởi động ứng dụng.
*   **Hệ thống thiết kế cao cấp (Premium UI/UX)**:
    *   Giao diện tinh chỉnh theo chuẩn thiết kế hiện đại, mượt mà.
    *   Hỗ trợ tối ưu hóa vùng chạm của các nút hành động (Touch target minimum 48x48px).
    *   Hệ thống màu sắc đồng bộ thông qua `AppTheme`.

---

## 🏗️ Kiến Trúc Dự Án (Clean Architecture)

Dự án được phân tách rõ ràng thành 3 tầng cốt lõi nhằm tối ưu hóa tính độc lập, bảo trì và kiểm thử:

```text
lib/
├── core/                   # Cấu hình chung, định nghĩa theme, routes, strings
│   ├── routes/             # Định tuyến màn hình
│   ├── theme/              # Định nghĩa giao diện sáng/tối
│   └── values/             # Các hằng số, chuỗi văn bản dùng chung
│
├── domain/                 # Tầng Nghiệp vụ (Chỉ chứa logic nghiệp vụ thuần khiết)
│   ├── entities/           # Thực thể dữ liệu thuần Dart (ví dụ: Product)
│   ├── repositories/       # Giao diện (Interface) của Repository
│   └── usecases/           # Các ca sử dụng cụ thể (GetProductsUseCase)
│
├── data/                   # Tầng Dữ liệu (Kết nối API, Database, File)
│   ├── datasources/        # Nguồn dữ liệu (Local Hive DB & Remote Dio API Client)
│   ├── models/             # Model dữ liệu riêng biệt của tầng data (ProductModel)
│   └── repositories/       # Hiện thực hóa (Implement) các Interface của Repository
│
└── presentation/           # Tầng Hiển thị (Giao diện người dùng)
    ├── bindings/           # Dependency Injection thông qua GetX Bindings
    ├── modules/            # Các mô-đun chức năng (Cart, Catalog, Login)
    │   ├── controller/     # Điều phối trạng thái (GetXController)
    │   └── view/           # Màn hình giao diện (UI)
    └── widgets/            # Các UI components dùng lại
```

> [!TIP]
> **ProductModel** được tách biệt hoàn toàn không kế thừa trực tiếp từ thực thể **Product** thuộc tầng Domain. Việc này giúp loại bỏ hoàn toàn lỗi trùng lặp thuộc tính trong bộ nhớ (Field Shadowing) và tuân thủ chặt chẽ nguyên lý Clean Architecture.

---

## 🛠️ Công Nghệ & Thư Viện Sử Dụng

*   **Core**: Flutter SDK (`>=3.11.0`) & Dart.
*   **State Management**: [GetX](https://pub.dev/packages/get) - Quản lý trạng thái và định tuyến (Routing) tập trung.
*   **Networking**: [Dio](https://pub.dev/packages/dio) - HTTP Client kết nối và tương tác RESTful API.
*   **Local Storage**: [Hive](https://pub.dev/packages/hive) & [Hive Flutter](https://pub.dev/packages/hive_flutter) - Cơ sở dữ liệu NoSQL dạng Key-Value có tốc độ truy xuất cực nhanh.
*   **Dependency Injection**: GetX Bindings (`InitialBinding`, `LoginBinding`).

---

## 🔧 Hướng Dẫn Cài Đặt & Chạy Dự Án

### 1. Chuẩn Bị
Đảm bảo bạn đã cài đặt Flutter SDK trên máy tính.

### 2. Tải Mã Nguồn & Cài Đặt Thư Viện
Mở terminal tại thư mục gốc của dự án và chạy lệnh sau để tải các thư viện phụ thuộc:
```bash
flutter pub get
```

### 3. Sinh Mã Tự Động (Code Generation)
Dự án sử dụng `build_runner` để tự động tạo bộ Adapter cho Hive (`ProductModelAdapter`). Chạy lệnh sau để tạo file:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Cấu Hình Địa Chỉ API (Dành Cho Máy Ảo)
Nếu chạy ứng dụng trên máy ảo Android (Android Emulator), địa chỉ `localhost` của máy tính sẽ được ánh xạ qua IP: **`10.0.2.2`**. 

Bạn có thể chỉnh sửa cấu hình này tại [dio_client.dart](file:///D:/Job/Projects/week3-Flutter/Level-4---App-with-RestfulAPI/lib/data/datasources/remote/dio_client.dart#L29):
```dart
_dio.options.baseUrl = 'http://10.0.2.2:1997/api/v1';
```

### 5. Chạy Dự Án
```bash
flutter run
```
