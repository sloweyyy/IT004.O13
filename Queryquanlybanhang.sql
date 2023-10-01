USE quanlybanhang;

-- [1]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM
WHERE NUOCSX = 'Trung Quoc';

-- [2]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM
WHERE DVT = 'cay'
      OR DVT = 'quyen';

-- [3]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM
WHERE MASP LIKE 'B%01';

-- [4]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM
WHERE NUOCSX = 'Trung Quoc'
      AND GIA >= 30000;

-- [5]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM
WHERE (
          NUOCSX = 'Trung Quoc'
          OR NUOCSX = 'Thai Lan'
      )
      AND
      (
          GIA >= 30000
          AND GIA <= 40000
      );

-- [6]
SELECT SOHD,
       TRIGIA
FROM dbo.HOADON
WHERE NGHD = '2007/01/01'
      OR NGHD = '2007/01/02';

-- [7]
SELECT SOHD,
       TRIGIA,
       NGHD
FROM dbo.HOADON
WHERE MONTH(NGHD) = '01'
      AND YEAR(NGHD) = '2007'
ORDER BY NGHD ASC,
         TRIGIA DESC;

-- [8]
SELECT H.MAKH,
       K.HOTEN
FROM dbo.HOADON H
    FULL JOIN dbo.KHACHHANG K
        ON K.MAKH = H.MAKH
WHERE NGHD = '2007/01/01';

-- [9]
SELECT H.SOHD,
       H.TRIGIA
FROM dbo.HOADON H
    FULL JOIN dbo.NHANVIEN N
        ON N.MANV = H.MANV
WHERE N.HOTEN = 'Nguyen Van B';

-- [10]
SELECT S.MASP,
       S.TENSP
FROM dbo.SANPHAM S
    FULL JOIN dbo.CTHD C
        ON C.MASP = S.MASP
    FULL JOIN dbo.HOADON H
        ON H.SOHD = C.SOHD
    FULL JOIN dbo.KHACHHANG K
        ON K.MAKH = H.MAKH
WHERE K.HOTEN = 'Nguyen Van A'
      AND MONTH(H.NGHD) = 10
      AND YEAR(H.NGHD) = 2006;

-- [11]
SELECT SOHD
FROM dbo.CTHD
WHERE MASP = 'BB01'
      OR MASP = 'BB02';

-- [12]
SELECT SOHD
FROM CTHD
WHERE (
          MASP = 'BB01'
          OR MASP = 'BB02'
      )
      AND SL
      BETWEEN 10 AND 20;

-- [13]
SELECT SOHD
FROM CTHD
WHERE SL
      BETWEEN 10 AND 20
      AND MASP = 'BB01'
      AND SOHD IN
          (
              SELECT SOHD FROM CTHD WHERE MASP = 'BB02'
          );