# Wireframe Mobile Native cho SmartLog WMS

Tài liệu chi tiết theo từng screen đã được tách riêng để dễ review và triển khai.

## Kế hoạch chuyển đổi
- [Kế hoạch chuyển đổi webapp sang Flutter](ke-hoach-chuyen-doi-webapp-sang-flutter.md)

## Kế hoạch thực thi slice 1
- [00. Đề xuất sử dụng skill cho vertical slice 1](plans/2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/00-skill-usage-proposal.md)
- [Plan vertical slice 1](plans/2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan.md)

## Cập nhật mới nhất
- 2026-03-25: Hoàn tất Flutter vertical slice 1 (`login -> shell -> tasks -> receipt -> scan receive`),
  bao gồm regression tests, integration tests, và tài liệu chạy local trong `mobile/README.md`.

## Mục tiêu chính
- Tối ưu thao tác kho nhanh, ít chạm.
- Ưu tiên quét barcode/QR, xác nhận số lượng và xử lý đơn ngay tại hiện trường.
- Hiển thị rõ trạng thái tồn kho, đơn chờ xử lý, và cảnh báo realtime.
- Phân quyền theo RBAC, chỉ hiện tính năng phù hợp với vai trò.

## Mục lục wireframe
- [00. App Shell và Điều hướng](mobile-wireframes/00-app-shell-va-dieu-huong.md)
- [01. Đăng nhập](mobile-wireframes/01-dang-nhap.md)
- [02. Dashboard tổng quan](mobile-wireframes/02-dashboard-tong-quan.md)
- [03. Scan / Nhập-Xuất nhanh](mobile-wireframes/03-scan-giao-dich.md)
- [04. Danh sách tồn kho](mobile-wireframes/04-danh-sach-ton-kho.md)
- [05. Chi tiết tồn kho](mobile-wireframes/05-chi-tiet-ton-kho.md)
- [06. Báo cáo realtime](mobile-wireframes/06-bao-cao-realtime.md)
- [07. Tài khoản và RBAC](mobile-wireframes/07-tai-khoan-rbac.md)
- [08. Danh sách phiếu nhập](mobile-wireframes/08-phieu-nhap-danh-sach.md)
- [09. Chi tiết phiếu nhập](mobile-wireframes/09-chi-tiet-phieu-nhap.md)
- [10. Danh sách phiếu xuất kho](mobile-wireframes/10-phieu-xuat-danh-sach.md)
- [11. Chi tiết phiếu xuất kho](mobile-wireframes/11-chi-tiet-phieu-xuat.md)
- [12. OCR chụp và xử lý](mobile-wireframes/12-ocr-chup-va-xu-ly.md)
- [13. Kiểm kê và chuyển vị trí](mobile-wireframes/13-kiem-ke-va-chuyen-vi-tri.md)
- [14. Hàng chờ xử lý và cảnh báo](mobile-wireframes/14-hang-cho-xu-ly-va-canh-bao.md)

## Tài liệu sát implementation
- [01. App Shell, Bottom Navigation và Role Matrix](mobile-implementation/01-app-shell-navigation-role-matrix.md)
- [02. Task Flow Scan, OCR, Inbound và Outbound](mobile-implementation/02-task-flow-scan-ocr-inbound-outbound.md)
- [03. Flutter Folder Structure, Route Config và State Management Map](mobile-implementation/03-flutter-folder-structure-route-state-map.md)
- [04. Contracts Dart Samples](mobile-implementation/contracts/README.md)

## Điều hướng mobile đề xuất
- Bottom navigation cho 3 đến 4 mục dùng nhiều nhất.
- Nút quét nổi ở trung tâm cho tác vụ cốt lõi.
- Mục ít dùng hoặc quản trị sâu đưa vào tab Tài khoản / More.

## Thứ tự triển khai khuyến nghị
1. App Shell và điều hướng.
2. Đăng nhập.
3. Dashboard tổng quan.
4. Scan / OCR / nhập-xuất nhanh.
5. Danh sách tồn kho.
6. Chi tiết tồn kho.
7. Danh sách phiếu nhập.
8. Chi tiết phiếu nhập.
9. Danh sách phiếu xuất kho.
10. Chi tiết phiếu xuất kho.
11. Kiểm kê và chuyển vị trí.
12. Hàng chờ xử lý và cảnh báo.
13. Báo cáo realtime.
14. Tài khoản và RBAC.

## Trình tự sau wireframe
1. Chốt app shell, route map và role matrix.
2. Chốt task flow scan, OCR, inbound, outbound.
3. Chốt Flutter folder structure, route config và state management map.
4. Chốt DTO, enum và entity contract.
5. Mới bắt đầu dựng router, shell layout và feature module trong Flutter.
