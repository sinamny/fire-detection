# Fire Detection Project

## Mô tả
Dự án phát hiện và phân vùng đám cháy từ video sử dụng mô hình học máy. Dữ liệu đầu vào là video thời gian thực, và hệ thống sẽ xác định các khu vực có khả năng xảy ra cháy, vẽ khung viền quanh những khu vực này và xuất video với các vùng phát hiện lửa.

## Cài đặt

### Yêu cầu
- Python 3.8+
- PostgreSQL (hoặc cơ sở dữ liệu tương thích)
- Các thư viện Python yêu cầu: xem file `requirements.txt`

### Cài đặt môi trường
1. Tạo môi trường ảo:
   ```bash
   python -m venv myenv
   ```

2. Kích hoạt môi trường ảo:
   - Trên Windows:
     ```bash
     myenv\Scripts\activate
     ```
   - Trên macOS/Linux:
     ```bash
     source myenv/bin/activate
     ```

3. Cài đặt các thư viện phụ thuộc:
   ```bash
   pip install -r requirements.txt
   ```

### Cài đặt PostgreSQL

1. Cài đặt PostgreSQL (nếu chưa có) từ [PostgreSQL Official](https://www.postgresql.org/download/).
2. Tạo cơ sở dữ liệu mới, ví dụ: `fire_detection_db`.
3. Tạo bảng trong cơ sở dữ liệu bằng cách sử dụng các câu lệnh SQL trong tệp `schema.sql` (nếu có).

### Cấu hình kết nối PostgreSQL

1. Chỉnh sửa thông tin kết nối trong tệp `database/__init__.py`:
   ```python
   conn = psycopg2.connect(
       host="localhost",       # Hoặc địa chỉ máy chủ nếu không phải localhost
       database="fire_detection_db",  # Tên cơ sở dữ liệu
       user="postgres",        # Tên người dùng PostgreSQL
       password="your_password",       # Mật khẩu người dùng PostgreSQL
       port="5432"             # Cổng kết nối PostgreSQL (mặc định là 5432)
   )
   ```

### Chạy dự án

1. Để chạy ứng dụng, sử dụng lệnh sau:
   ```bash
   python database/__init__.py
   ```

2. Hệ thống sẽ tự động kết nối tới cơ sở dữ liệu và thực hiện các tác vụ cần thiết để phát hiện đám cháy trong video.

