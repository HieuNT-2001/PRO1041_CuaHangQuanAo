-- TẠO DATABASE
CREATE DATABASE PRO1041_CuaHangQuanAo
GO

USE PRO1041_CuaHangQuanAo
GO

-- TẠO BẢNG NHÂN VIÊN
CREATE TABLE NhanVien
(
    MaNV INT PRIMARY KEY IDENTITY(1,1),
    TenDangNhap VARCHAR(20) NOT NULL,
    MatKhau VARCHAR(50) NOT NULL,
    HoTen NVARCHAR(50) NOT NULL,
    NamSinh INT NOT NULL CHECK(NamSinh > 0),
    SDT VARCHAR(10) NOT NULL,
    CCCD VARCHAR(12) NOT NULL,
    VaiTro BIT NOT NULL
)
GO

-- TẠO BẢNG KHÁCH HÀNG
CREATE TABLE KhachHang
(
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    TenKH NVARCHAR(50) NOT NULL,
    SDT VARCHAR(10) NOT NULL,
    Email VARCHAR(255),
    DiaChi VARCHAR(255) NOT NULL
)
GO

-- TẠO BẢNG NHÀ CUNG CẤP
CREATE TABLE NhaCungCap
(
    MaNCC INT PRIMARY KEY IDENTITY(1,1),
    TenNCC NVARCHAR(50) NOT NULL,
    SDT VARCHAR(10) NOT NULL,
    Email VARCHAR(255),
    DiaChi VARCHAR(255) NOT NULL
)
GO

-- TẠO BẢNG THUỘC TÍNH SẢN PHẨM
CREATE TABLE ThuocTinhSP
(
    MaThuocTinh INT PRIMARY KEY IDENTITY(1,1),
    TenThuocTinh NVARCHAR(20) NOT NULL,
    GiaTri NVARCHAR(20) NOT NULL
)
GO

-- TẠO BẢNG KHUYẾN MẠI
CREATE TABLE KhuyenMai
(
    MaKM VARCHAR(20) PRIMARY KEY,
    TenKM NVARCHAR(50) NOT NULL,
    NgayBD DATE NOT NULL,
    NgayKT DATE NOT NULL,
    GiamGia FLOAT NOT NULL CHECK (GiamGia BETWEEN 0 and 1)
)
GO

-- TẠO BẢNG SẢN PHẨM
CREATE TABLE SanPham
(
    MaSP INT PRIMARY KEY IDENTITY(1,1),
    TenSP NVARCHAR(50) NOT NULL,
    DonGia FLOAT NOT NULL CHECK(DonGia > 0),
    SoLuong INT NOT NULL CHECK(SoLuong >= 0),
    MaNCC INT NOT NULL,
    LoaiSP NVARCHAR(20) NOT NULL,
    MauSac NVARCHAR(20) NOT NULL,
    KichThuoc NVARCHAR(20) NOT NULL,
    ChatLieu NVARCHAR(20) NOT NULL,
    TrangThai BIT NOT NULL,
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap (MaNCC)
)
GO

-- TẠO BẢNG HOÁ ĐƠN
CREATE TABLE HoaDon
(
    MaHD INT PRIMARY KEY IDENTITY(1,1),
    MaNV INT NOT NULL,
    MaKH INT,
    MaKM VARCHAR(20),
    KenhBanHang BIT NOT NULL,
    NgayTao DATE NOT NULL,
    TrangThai INT NOT NULL,
    LyDo NVARCHAR(255),
    FOREIGN KEY (MaNV) REFERENCES NhanVien (MaNV),
    FOREIGN KEY (MaKH) REFERENCES KhachHang (MaKH),
    FOREIGN KEY (MaKM) REFERENCES KhuyenMai (MaKM)
)
GO

-- TẠO BẢNG HÓA ĐƠN CHI TIẾT
CREATE TABLE HoaDonChiTiet
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    MaHD INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL,
    FOREIGN KEY (MaHD) REFERENCES HoaDon (MaHD),
    FOREIGN KEY (MaSP) REFERENCES SanPham (MaSP)
)
GO

-- TẠO SP
-- SP LẤY DANH SÁCH SẢN PHẨM
CREATE OR ALTER PROC get_sanPham
    (@TrangThai INT)
AS
SELECT DISTINCT
    'SP' + FORMAT(MaSP, '0000') AS MaSP,
    TenSP,
    TenNCC,
    LoaiSP,
    MauSac,
    KichThuoc,
    ChatLieu,
    DonGia,
    SoLuong,
    TrangThai
FROM SanPham sp
    JOIN NhaCungCap ncc ON sp.MaNCC = ncc.MaNCC
WHERE TrangThai = @TrangThai
ORDER BY MaSP ASC
GO

-- SP LẤY DANH SÁCH HÓA ĐƠN
CREATE OR ALTER PROC get_hoaDon
    (@TrangThai INT)
AS
SELECT DISTINCT
    'HD' + FORMAT(hd.MaHD, '0000') AS MaHD,
    nv.HoTen AS NguoiTao,
    NgayTao,
    KenhBanHang,
    ISNULL(kh.TenKH, '') AS KhachHang,
    ISNULL(hd.MaKM, '') AS MaKM,
    SUM(sp.DonGia*hdct.SoLuong) AS TongThanhTien,
    SUM(sp.DonGia*hdct.SoLuong * ISNULL(km.GiamGia, 0)) AS GiamGiaHD,
    SUM(sp.DonGia*hdct.SoLuong * (1 - ISNULL(km.GiamGia, 0))) AS TongThanhToan,
    hd.TrangThai,
    LyDo
FROM HoaDon hd
    JOIN NhanVien nv ON hd.MaNV = nv.MaNV
    LEFT JOIN KhachHang kh ON hd.MaKH = kh.MaKH
    LEFT JOIN KhuyenMai km on hd.MaKM = km.MaKM
    JOIN HoaDonChiTiet hdct ON hd.MaHD = hdct.MaHD
    JOIN SanPham sp ON hdct.MaSP = sp.MaSP
WHERE hd.TrangThai = @TrangThai
GROUP BY hd.MaHD,
    nv.HoTen,
    hd.NgayTao,
    hd.KenhBanHang,
    kh.TenKH,
    hd.MaKM,
    hd.TrangThai,
    hd.LyDo
ORDER BY hd.NgayTao DESC
GO

-- SP LẤY DOANH THU NGÀY HÔM NAY
CREATE OR ALTER PROC get_doanhThu_today
AS
SELECT
    ISNULL(SUM(sp.DonGia*hdct.SoLuong * (1 - ISNULL(km.GiamGia, 0))), 0)
FROM SanPham sp
    JOIN HoaDonChiTiet hdct ON sp.MaSP = hdct.MaSP
    JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
    LEFT JOIN KhuyenMai km on hd.MaKM = km.MaKM
WHERE hd.NgayTao = CONVERT(DATE, GETDATE()) 
GO

-- SP LẤY DOANH THU THEO NGÀY
CREATE OR ALTER PROC get_doanhThu_byDate(
    @start DATE,
    @end DATE
)
AS
SELECT
    ISNULL(SUM(sp.DonGia*hdct.SoLuong * (1 - ISNULL(km.GiamGia, 0))), 0)
FROM SanPham sp
    JOIN HoaDonChiTiet hdct ON sp.MaSP = hdct.MaSP
    JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
    LEFT JOIN KhuyenMai km on hd.MaKM = km.MaKM
WHERE hd.NgayTao BETWEEN @start and @end 
GO

-- SP LẤY DOANH THU THEO THÁNG HIỆN TẠI
CREATE OR ALTER PROC get_doanhThu_thisMonth
AS
SELECT
    ISNULL(SUM(sp.DonGia*hdct.SoLuong * (1 - ISNULL(km.GiamGia, 0))), 0)
FROM SanPham sp
    JOIN HoaDonChiTiet hdct ON sp.MaSP = hdct.MaSP
    JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
    LEFT JOIN KhuyenMai km on hd.MaKM = km.MaKM
WHERE MONTH(hd.NgayTao) = MONTH(GETDATE())
    AND YEAR(hd.NgayTao) = YEAR(GETDATE())
GO

-- SP LẤY DOANH THEO NĂM HIỆN TẠI
CREATE OR ALTER PROC get_doanhThu_thisYear
AS
SELECT
    ISNULL(SUM(sp.DonGia*hdct.SoLuong * (1 - ISNULL(km.GiamGia, 0))), 0)
FROM SanPham sp
    JOIN HoaDonChiTiet hdct ON sp.MaSP = hdct.MaSP
    JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
    LEFT JOIN KhuyenMai km on hd.MaKM = km.MaKM
WHERE YEAR(hd.NgayTao) = YEAR(GETDATE())
GO

-- SP LẤY CHI TIẾT DOANH THU
CREATE OR ALTER PROC get_doanhThu_detail
AS
SELECT DISTINCT
    MONTH(hd.NgayTao) AS Thang,
    SUM(hdct.SoLuong) AS SoLuongBan,
    SUM(sp.DonGia*hdct.SoLuong) AS TongGiaBan,
    SUM(sp.DonGia*hdct.SoLuong * ISNULL(km.GiamGia, 0)) AS TongGiamGia,
    SUM(sp.DonGia*hdct.SoLuong * (1 - ISNULL(km.GiamGia, 0))) AS TongDoanhThu
FROM SanPham sp
    JOIN HoaDonChiTiet hdct on sp.MaSP = hdct.MaSP
    JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
    LEFT JOIN KhuyenMai km ON hd.MaKM = km.MaKM
GROUP BY MONTH(hd.NgayTao)
ORDER BY MONTH(hd.NgayTao) ASC
GO

-- SP LẤY TOP 10 SẢN PHẨM BÁN CHẠY TRONG THÁNG
CREATE OR ALTER PROC get_top10_sanPham
AS
SELECT DISTINCT TOP 10
    'SP' + FORMAT(sp.MaSP, '0000') AS MaSP,
    TenSP,
    TenNCC,
    LoaiSP,
    MauSac,
    KichThuoc,
    ChatLieu,
    SUM(hdct.SoLuong) AS SoLuongBan
FROM NhaCungCap ncc
    JOIN SanPham sp ON ncc.MaNCC = sp.MaNCC
    JOIN HoaDonChiTiet hdct ON sp.MaSP = hdct.MaSP
GROUP BY sp.MaSP,
    TenSP,
    TenNCC,
    LoaiSP,
    MauSac,
    KichThuoc,
    ChatLieu
ORDER BY SoLuongBan DESC
GO

-- SP LẤY THÀNH TIỀN HÓA ĐƠN
CREATE OR ALTER PROC get_thanhTien
    (@MaHD INT)
AS
SELECT DISTINCT
    SUM(sp.DonGia*hdct.SoLuong) AS TongThanhTien
FROM SanPham sp
    JOIN HoaDonChiTiet hdct on sp.MaSP = hdct.MaSP
    JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
WHERE hd.MaHD = @MaHD
GO

-- SP LẤY GIẢM GIÁ HÓA ĐƠN
CREATE OR ALTER PROC get_giamGia
    (@MaHD INT)
AS
SELECT DISTINCT
    SUM(sp.DonGia*hdct.SoLuong * ISNULL(km.GiamGia, 0)) AS GiamGiaHD
FROM SanPham sp
    JOIN HoaDonChiTiet hdct on sp.MaSP = hdct.MaSP
    JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
    LEFT JOIN KhuyenMai km ON hd.MaKM = km.MaKM
WHERE hd.MaHD = @MaHD
GO

-- TRIGGER INSERT HÓA ĐƠN CHI TIẾT
CREATE OR ALTER TRIGGER insert_HoaDon ON HoaDonChiTiet
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE SanPham
            SET SoLuong = sp.SoLuong - i.SoLuong
        FROM SanPham sp
            JOIN inserted i ON sp.MaSP = i.MaSP
    END
END
GO

-- TRIGGER UPDATE HÓA ĐƠN CHI TIẾT
CREATE OR ALTER TRIGGER update_HoaDon ON HoaDonChiTiet
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE SanPham
            SET SoLuong = sp.SoLuong - (i.SoLuong - ISNULL(d.SoLuong, 0))
        FROM SanPham sp
            JOIN inserted i ON sp.MaSP = i.MaSP
            LEFT JOIN deleted d ON sp.MaSP = d.MaSP
    END
END
GO

-- TRIGGER HỦY HÓA ĐƠN
CREATE OR ALTER TRIGGER cancel_HoaDon ON HoaDon
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE TrangThai = 2)
    BEGIN
        UPDATE SanPham
            SET SoLuong = sp.SoLuong + hdct.SoLuong
        FROM SanPham sp
            JOIN HoaDonChiTiet hdct ON sp.MaSP = hdct.MaSP
            JOIN inserted i ON hdct.MaHD = i.MaHD
        WHERE i.TrangThai = 2
    END
END
GO

-- NHẬP DỮ LIỆU
-- NHẬP DỮ LIỆU NHÂN VIÊN
INSERT INTO NhanVien
    (TenDangNhap, MatKhau, HoTen, NamSinh, SDT, CCCD, VaiTro)
VALUES
    ('NamTP', '123', N'Trần Thành Nam', 1994, '0902123456', '045212345678', 1),
    ('ThuNV', '123', N'Bùi Thị Thu', 2000, '0902654321', '045287654321', 0)
GO

-- NHẬP DỮ LIỆU KHÁCH HÀNG
INSERT INTO KhachHang
    (TenKH, SDT, Email, DiaChi)
VALUES
    (N'Nguyễn Văn Tiến', '0984123456', '', N'Hải Phòng'),
    (N'Trần Thu Hằng', '0984654321', '', N'Hải Phòng'),
    (N'Phạm Hoài Giang', '0984225643', '', N'Hải Phòng')
GO

-- NHẬP DỮ LIỆU NHÀ CUNG CẤP
INSERT INTO NhaCungCap
    (TenNCC, SDT, Email, DiaChi)
VALUES
    (N'Công ty CP dệt may', '0625123456', '', N'Hải Phòng'),
    (N'Công ty TNHH thời trang', '0625654321', '', N'Hải Phòng'),
    (N'Công ty TNHH Fashion VietNam', '0625225643', '', N'Hải Phòng')
GO

-- NHẬP DỮ LIỆU THUỘC TÍNH SẢN PHẨM
INSERT INTO ThuocTinhSP
    (TenThuocTinh, GiaTri)
VALUES
    (N'Loại sản phẩm', N'Áo sơ mi'),
    (N'Màu sắc', N'Trắng'),
    (N'Kích thước', 'S'),
    (N'Kích thước', 'M'),
    (N'Kích thước', 'L'),
    (N'Chất liệu', N'Vải lụa')
GO

-- NHẬP DỮ LIỆU KHUYẾN MẠI
INSERT INTO KhuyenMai
    (MaKM, TenKM, NgayBD, NgayKT, GiamGia)
VALUES
    ('summer2024', N'Sale mùa hè 2024', '2024-01-06', '2024-07-30', 0.1)
GO

-- NHẬP DỮ LIỆU SẢN PHẨM
INSERT INTO SanPham
    (TenSP, DonGia, SoLuong, MaNCC, LoaiSP, MauSac, KichThuoc, ChatLieu, TrangThai)
VALUES
    (N'Áo sơ mi trắng', 120000, 100, 1, N'Áo sơ mi', N'Trắng', 'S', N'Vải lụa', 1),
    (N'Áo sơ mi trắng', 120000, 100, 1, N'Áo sơ mi', N'Trắng', 'M', N'Vải lụa', 1),
    (N'Áo sơ mi trắng', 120000, 100, 1, N'Áo sơ mi', N'Trắng', 'L', N'Vải lụa', 1)
GO

-- NHẬP DỮ LIỆU HÓA ĐƠN
INSERT INTO HoaDon
    (MaNV, MaKH, MaKM, KenhBanHang, NgayTao, TrangThai, LyDo)
VALUES
    (2, NULL, NULL, 0, '2024-06-30', 1, ''),
    (2, NULL, 'summer2024', 0, '2024-06-30', 1, '')
GO

-- NHẬP DỮ LIỆU HÓA ĐƠN CHI TIẾT
INSERT INTO HoaDonChiTiet
    (MaHD, MaSP, SoLuong)
VALUES
    (1, 1, 1),
    (2, 2, 1),
    (2, 3, 3)
GO

-- EXEC get_sanPham 1

-- EXEC get_hoaDon 1

-- EXEC get_doanhThu_today

-- EXEC get_doanhThu_byDate '2024-07-01', '2024-07-15'

-- EXEC get_doanhThu_thisMonth

-- EXEC get_doanhThu_thisYear

-- EXEC get_doanhThu_detail

-- EXEC get_thanhTien 1

-- EXEC get_giamGia 2
