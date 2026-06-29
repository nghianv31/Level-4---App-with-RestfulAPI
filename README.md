# Professional Commerce System (Level 4 - App with RESTful API)

Dự án Flutter quản lý sản phẩm và giỏ hàng, áp dụng **Clean Architecture** kết hợp với quản lý trạng thái **GetX**, tích hợp kết nối **RESTful API** và lưu trữ dữ liệu cục bộ bằng **Hive**.

## Demo 
<p align="center">
  <video src="https://github.com/user-attachments/assets/9d936623-a2a0-41d3-94a5-faad16b3d28e" width="400" controls></video>
</p>

---

## 1. Mục tiêu tuần (Weekly Goals)

### Mục tiêu chính
* **Xây dựng ứng dụng tích hợp RESTful API:** Tương tác với server thật để lấy dữ liệu (GET), thêm mới (POST), cập nhật (PUT), xóa (DELETE) danh sách sản phẩm và danh mục.
* **Áp dụng Clean Architecture chuẩn:** Chia tách dự án thành 3 layer độc lập (Domain, Data, Presentation) để dễ dàng kiểm thử và mở rộng.
* **Quản lý state & Routing với GetX:** Phân tách Logic và UI, xử lý tiêm phụ thuộc (Dependency Injection) tối ưu.
* **Local Storage với Hive:** Caching giỏ hàng offline, lưu thông tin session/settings nhanh chóng với Hive NoSQL.

### Mở rộng & Nâng cao
* **Áp dụng các tính năng, logic Login của BT1 vào project**
  * Giới hạn số lần đăng nhập sai
  * Auto fill
  * Animation khi nhập sai
* **Tính năng Danh mục (Catalog):**
  * Hỗ trợ tìm kiếm (Search) có Debounce.
  * Lọc theo danh mục (Filter by Category).
  * Sắp xếp theo tên hoặc giá (Sort).
  * Phân trang và cuộn vô hạn (Pagination & Infinite Scroll).
* **Trải nghiệm Giỏ hàng (Cart):**
  * Tích hợp hoạt ảnh (Animation) khi thêm sản phẩm bay vào giỏ hàng.
  * Tự động tính toán tổng số lượng, tổng tiền.
  * Đồng bộ dữ liệu giỏ hàng xuống Hive DB để không mất dữ liệu khi đóng app.
* **UI/UX**
  * Optimistic update
---

## 2. Kiến Trúc Dự Án (Clean Architecture)

Dự án tuân thủ nghiêm ngặt mô hình **Clean Architecture** kết hợp **GetX**, gồm 3 tầng cốt lõi:

```text
lib/
├── core/                   # Cấu hình chung, định nghĩa theme, routes, strings, exceptions
│
├── domain/                 # Tầng Nghiệp vụ (Chỉ chứa logic nghiệp vụ thuần khiết)
│   ├── entities/           # Thực thể dữ liệu thuần Dart (ví dụ: Product, Category)
│   ├── repositories/       # Giao diện (Interface) của Repository
│   └── usecases/           # Các ca sử dụng cụ thể (GetProductsUseCase, AddCartUseCase)
│
├── data/                   # Tầng Dữ liệu (Kết nối API, Database, File)
│   ├── datasources/        # Nguồn dữ liệu (Local Hive DB & Remote Dio API Client)
│   ├── models/             # Model dữ liệu riêng biệt (ProductModel, ánh xạ từ Entity)
│   └── repositories/       # Hiện thực hóa (Implement) các Interface của Repository ở Domain
│
└── presentation/           # Tầng Hiển thị (Giao diện người dùng)
    ├── bindings/           # Dependency Injection thông qua GetX Bindings (InitialBinding)
    ├── modules/            # Các màn hình (Catalog, Cart, Categories)
    │   ├── controller/     # Điều phối trạng thái (GetXController)
    │   └── view/           # Màn hình giao diện (UI)
    └── widgets/            # Các UI components dùng chung (CustomSnackbar, CartAnimation)
```

> [!TIP]
> **Data Models vs Entities**: `ProductModel` ở tầng Data được tách biệt hoàn toàn và không kế thừa trực tiếp từ thực thể `Product` thuộc tầng Domain. Việc mapping qua lại giúp loại bỏ rủi ro phụ thuộc logic và tuân thủ chặt chẽ nguyên lý Clean Architecture.

---

## 3. Cách chạy dự án (How to run)

### Yêu cầu môi trường (Env)
* Flutter SDK (`>=3.11.0`).
* Một RESTful API Server đang chạy. Nếu bạn dùng máy ảo (Android Emulator) trỏ về local server trên máy thật, địa chỉ `localhost` của máy tính sẽ được ánh xạ qua IP: `10.0.2.2`.

### Cấu hình biến môi trường & API Base URL
Mở file `lib/data/datasources/remote/dio_client.dart` và điều chỉnh `baseUrl` cho phù hợp với backend của bạn:
```dart
// Ví dụ khi chạy backend local port 1997
_dio.options.baseUrl = 'http://10.0.2.2:1997/api/v1'; 
```
*(Nếu bạn có sử dụng `.env`, hãy đảm bảo thêm URL vào file cấu hình môi trường tương ứng).*

### Sinh mã tự động (Code Generation)
Do dự án sử dụng `Hive` nên cần tự động tạo các bộ TypeAdapter.
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Dữ liệu mẫu (Sample Data)
Ứng dụng yêu cầu backend cung cấp các API sau:
* `GET /products` (Có hỗ trợ query `page`, `limit`).
* `POST /products`, `PUT /products/:id`, `DELETE /products/:id`.
* `GET /categories`.
* Nếu server chưa có data, bạn có thể tạo thủ công thông qua tính năng Thêm sản phẩm trực tiếp trên App.

Chạy dự án:
```bash
flutter run
```

---

## 4. Flow chính (Luồng hoạt động)

1. **Khởi tạo hệ thống (`main.dart` & `InitialBinding`):**
   * Khởi tạo `Hive`, đăng ký các Adapter và mở các Box (như Cart box).
   * Khởi tạo kết nối mạng `DioClient`.
   * Tiêm (Inject) toàn bộ Repositories và UseCases vào hệ thống bộ nhớ của GetX.

2. **Luồng Danh mục & Sản phẩm (Catalog Flow):**
   * Mở ứng dụng vào `CatalogView`. `CatalogController` gọi API lấy danh mục và danh sách sản phẩm trang 1.
   * Quá trình load data đi qua: View -> Controller -> UseCase -> Repository -> DioClient -> Server.
   * Khi cuộn xuống cuối, tự động tăng `currentPage` và load thêm dữ liệu.
   * Người dùng có thể **Tìm kiếm (Search)**, **Lọc (Filter)** theo category, và **Sắp xếp (Sort)** theo giá/tên trực tiếp trên local hoặc API.

3. **Luồng Thao tác Dữ liệu (CRUD Flow):**
   * Người dùng nhấn thêm hoặc sửa sản phẩm -> Mở Dialog/Form.
   * Điền thông tin -> Gọi API POST/PUT -> Cập nhật thành công -> `CatalogController` update lại danh sách hiển thị (`filteredProducts`).

4. **Luồng Giỏ hàng (Cart Flow):**
   * Người dùng bấm "Thêm vào giỏ" ở Catalog -> Kích hoạt `CartAnimationUtil` bay hình ảnh sản phẩm vào icon giỏ hàng góc màn hình.
   * `CartController` nhận data -> Gọi UseCase lưu sản phẩm vào `Hive` (Local DB).
   * Tổng số lượng & tổng tiền được tính toán lại ngay lập tức (Reactive bằng `Obx`).
   * Khi mở màn hình `CartView`, dữ liệu giỏ hàng được load trực tiếp từ Hive.
