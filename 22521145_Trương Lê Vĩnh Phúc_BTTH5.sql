
-- [8]
CREATE TRIGGER check_price
ON dbo.SANPHAM
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Inserted WHERE Inserted.GIA < 500)
    BEGIN
        RAISERROR('Giá bán của sản phẩm từ 500 đồng trở lên.', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- [9]
CREATE TRIGGER check_buying
ON dbo.HOADON
AFTER INSERT
AS
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM Inserted i
            LEFT JOIN dbo.CTHD C
                ON C.SOHD = i.SOHD
        WHERE C.SOHD IS NULL
    )
    BEGIN
        RAISERROR('Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- [10] 
CREATE TRIGGER check_registration_date
ON dbo.KHACHHANG
INSTEAD OF INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Inserted i WHERE i.NGDK > i.NGSINH)
    BEGIN
        RAISERROR('Ngày đăng ký phải lớn hơn ngày sinh của khách hàng.', 16, 1);
        ROLLBACK;
    END;
    ELSE
    BEGIN
        INSERT INTO dbo.KHACHHANG
        (
            MAKH,
            HOTEN,
            DCHI,
            SODT,
            NGSINH,
            DOANHSO,
            NGDK
        )
        SELECT MAKH,
               HOTEN,
               DCHI,
               SODT,
               NGSINH,
               DOANHSO,
               NGDK
        FROM inserted;
    END;
END;
GO

-- [11]
CREATE TRIGGER check_buy_date
ON dbo.HOADON
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM inserted i
            JOIN dbo.KHACHHANG k
                ON i.MAKH = k.MAKH
        WHERE k.NGDK > i.NGHD
    )
    BEGIN
        RAISERROR('Ngày mua hàng >= Ngày đăng ký thành viên', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- [12]
CREATE TRIGGER check_sale_date
ON dbo.HOADON
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM inserted i
            JOIN dbo.NHANVIEN n
                ON i.MANV = n.MANV
        WHERE i.NGHD < n.NGVL
    )
    BEGIN
        RAISERROR('Ngày bán hàng phải lớn hơn hoặc bằng ngày nhân viên vào làm', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- [13]
CREATE TRIGGER check_details
ON dbo.HOADON
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM inserted i
            LEFT JOIN dbo.CTHD c
                ON i.SOHD = c.SOHD
        WHERE c.SOHD IS NULL
    )
    BEGIN
        RAISERROR('Mỗi hóa đơn phải có ít nhất một chi tiết hóa đơn.', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- [14]
CREATE TRIGGER update_total
ON dbo.CTHD
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE h
    SET h.TRIGIA = ISNULL(
                   (
                       SELECT SUM(c.SL * s.GIA)
                       FROM dbo.CTHD c
                           INNER JOIN dbo.SANPHAM s
                               ON c.MASP = s.MASP
                       WHERE c.SOHD = h.SOHD
                   ),
                   0
                         )
    FROM dbo.HOADON h
        INNER JOIN inserted i
            ON h.SOHD = i.SOHD;
END;

