Bộ xử lý ARM Single-Cycle

Dự án xây dựng bộ xử lý đơn chu kỳ (Single-Cycle Processor) 32-bit lấy cảm hứng từ kiến trúc ARM, được thiết kế bằng ngôn ngữ SystemVerilog và phát triển trên phần mềm Intel Quartus Prime.

1. Giới thiệu

Dự án triển khai kiến trúc bộ xử lý trong đó mỗi lệnh được thực hiện hoàn tất trong một chu kỳ xung nhịp.

Thiết kế được tổ chức thành hai khối chính:

Khối điều khiển (Control Unit): Giải mã lệnh và tạo các tín hiệu điều khiển cho toàn bộ bộ xử lý.

Khối đường dữ liệu (Datapath): Thực hiện các phép toán, thao tác với thanh ghi, truy cập bộ nhớ và cập nhật bộ đếm chương trình (PC).

2. Các chức năng chính

Bộ xử lý có độ rộng dữ liệu 32-bit.

Tập thanh ghi gồm 16 thanh ghi.

Thực hiện các phép toán số học và logic.

Hỗ trợ các phép dịch bit thông qua Barrel Shifter.

Giải mã lệnh và tạo tín hiệu điều khiển.

Bộ nhớ lệnh (Instruction Memory).

Bộ nhớ dữ liệu (Data Memory).

Hỗ trợ các lệnh rẽ nhánh.

Hỗ trợ logic thực thi có điều kiện.

Có Testbench để kiểm tra hoạt động của bộ xử lý.
