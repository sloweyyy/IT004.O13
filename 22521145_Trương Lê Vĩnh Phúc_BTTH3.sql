USE quanlybanhang;

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

-- [14]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM S
WHERE NUOCSX = 'Trung Quoc'
UNION
SELECT S.MASP,
       S.TENSP
FROM dbo.SANPHAM S
    INNER JOIN dbo.CTHD C
        ON C.MASP = S.MASP
    INNER JOIN dbo.HOADON H
        ON C.SOHD = H.SOHD
WHERE H.NGHD = '1/1/2007';

-- [15]
SELECT S.MASP,
       S.TENSP
FROM dbo.SANPHAM S
WHERE NOT EXISTS
(
    SELECT * FROM dbo.CTHD C WHERE S.MASP = C.MASP
);

-- [16]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM
WHERE MASP IN
      (
          SELECT MASP
          FROM dbo.SANPHAM
          EXCEPT
          (SELECT MASP
           FROM dbo.CTHD
           WHERE SOHD IN
                 (
                     SELECT SOHD FROM dbo.HOADON WHERE YEAR(NGHD) = 2006
                 ))
      );

-- [17]
SELECT MASP,
       TENSP
FROM dbo.SANPHAM
WHERE NUOCSX = 'Trung Quoc'
      AND MASP IN
          (
              SELECT MASP
              FROM dbo.SANPHAM
              EXCEPT
              (SELECT MASP
               FROM dbo.CTHD
               WHERE SOHD IN
                     (
                         SELECT SOHD FROM dbo.HOADON WHERE YEAR(NGHD) = 2006
                     ))
          );

-- [18.1]
SELECT DISTINCT
       C1.SOHD
FROM CTHD C1
WHERE NOT EXISTS
(
    SELECT MASP
    FROM dbo.SANPHAM
    WHERE NUOCSX = 'Singapore'
    EXCEPT
    SELECT MASP
    FROM CTHD C2
    WHERE C2.SOHD = C1.SOHD
);

-- [18.2]
SELECT H.SOHD
FROM dbo.HOADON H
    INNER JOIN dbo.CTHD C
        ON H.SOHD = C.SOHD
    INNER JOIN dbo.SANPHAM S
        ON S.MASP = C.MASP
WHERE S.NUOCSX = 'Singapore'
GROUP BY H.SOHD
HAVING COUNT(DISTINCT S.MASP) =
(
    SELECT COUNT(DISTINCT MASP)FROM dbo.SANPHAM WHERE NUOCSX = 'Singapore'
);

-- [18.3]
SELECT DISTINCT
       C1.SOHD
FROM dbo.CTHD C1
WHERE NOT EXISTS
(
    SELECT *
    FROM dbo.SANPHAM S
    WHERE S.NUOCSX = 'Singapore'
          AND NOT EXISTS
    (
        SELECT * FROM CTHD C2 WHERE C2.SOHD = C1.SOHD AND C2.MASP = S.MASP
    )
);


-- [19.1]
SELECT H.SOHD
FROM dbo.HOADON H
    INNER JOIN dbo.CTHD C
        ON H.SOHD = C.SOHD
    INNER JOIN dbo.SANPHAM S
        ON C.MASP = S.MASP
WHERE YEAR(H.NGHD) = 2006
      AND S.NUOCSX = 'Singapore'
GROUP BY H.SOHD
HAVING COUNT(DISTINCT S.MASP) =
(
    SELECT COUNT(DISTINCT MASP)FROM dbo.SANPHAM WHERE NUOCSX = 'Singapore'
);

-- [19.2]
SELECT DISTINCT
       C1.SOHD
FROM CTHD C1
    JOIN HOADON H
        ON C1.SOHD = H.SOHD
           AND YEAR(H.NGHD) = 2006
WHERE NOT EXISTS
(
    SELECT MASP
    FROM SANPHAM
    WHERE NUOCSX = 'Singapore'
    EXCEPT
    SELECT MASP
    FROM CTHD C2
    WHERE C2.SOHD = C1.SOHD
);

-- [19.3]
SELECT DISTINCT
       C1.SOHD
FROM CTHD C1
    JOIN HOADON H
        ON C1.SOHD = H.SOHD
           AND YEAR(H.NGHD) = 2006
WHERE NOT EXISTS
(
    SELECT *
    FROM SANPHAM S
    WHERE S.NUOCSX = 'Singapore'
          AND NOT EXISTS
    (
        SELECT * FROM CTHD C2 WHERE C2.SOHD = C1.SOHD AND C2.MASP = S.MASP
    )
);

-- [20]
SELECT COUNT(SOHD)
FROM dbo.HOADON
WHERE MAKH IS NULL;

-- [21]
SELECT COUNT(DISTINCT (C.MASP)) AS SOSANPHAM
FROM dbo.CTHD C
    INNER JOIN dbo.HOADON H
        ON H.SOHD = C.SOHD
WHERE YEAR(H.NGHD) = 2006;

-- [22]
SELECT MAX(TRIGIA) AS CAONHAT,
       MIN(TRIGIA) AS THAPNHAT
FROM dbo.HOADON;

-- [23]
SELECT AVG(TRIGIA) AS TRUNGBINH
FROM dbo.HOADON
WHERE YEAR(NGHD) = 2006;

-- [24]
SELECT SUM(TRIGIA)
FROM dbo.HOADON
WHERE YEAR(NGHD) = 2006;

-- [25]
SELECT TOP 1
       SOHD
FROM dbo.HOADON
ORDER BY TRIGIA DESC;

-- [26]
SELECT HOTEN
FROM dbo.KHACHHANG
WHERE MAKH =
(
    SELECT TOP 1 H.MAKH FROM dbo.HOADON H ORDER BY H.TRIGIA DESC
);

-- [27]
SELECT TOP 3
       MAKH,
       HOTEN
FROM dbo.KHACHHANG
ORDER BY DOANHSO DESC;


-- [28]
SELECT TOP 1 WITH TIES
       MASP,
       TENSP
FROM dbo.SANPHAM
ORDER BY GIA DESC;

-- [29]
SELECT TOP 1 WITH TIES
       MASP,
       TENSP
FROM dbo.SANPHAM
WHERE NUOCSX = 'Thai Lan'
ORDER BY GIA DESC;

-- [30]
SELECT TOP 1
       MASP,
       TENSP
FROM dbo.SANPHAM
WHERE NUOCSX = 'Trung Quoc'
      AND MASP IN
          (
              SELECT MASP FROM dbo.SANPHAM WHERE NUOCSX = 'Trung Quoc'
          )
ORDER BY GIA DESC;

-- [31]
SELECT TOP 3 WITH TIES
       MAKH,
       HOTEN
FROM dbo.KHACHHANG
ORDER BY DOANHSO DESC;

-- [32]
SELECT COUNT(MASP) AS SOSANPHAM
FROM dbo.SANPHAM
WHERE NUOCSX = 'Trung Quoc'
GROUP BY NUOCSX;

-- [33]
SELECT COUNT(MASP) AS SOSANPHAM,
       NUOCSX
FROM dbo.SANPHAM
GROUP BY NUOCSX;

-- [34]
SELECT MAX(GIA) AS GIACAONHAT,
       MIN(GIA) AS GIATHAPNHAT,
       AVG(GIA) AS GIATRUNGBINH
FROM dbo.SANPHAM
GROUP BY NUOCSX;

-- [35]
SELECT SUM(TRIGIA) AS DOANHTHU,
       NGHD
FROM dbo.HOADON
GROUP BY NGHD;

-- [36]
SELECT C.MASP,
       SUM(C.SL) AS SOLUONG
FROM dbo.CTHD C
    INNER JOIN dbo.HOADON H
        ON H.SOHD = C.SOHD
WHERE MONTH(H.NGHD) = 10
      AND YEAR(H.NGHD) = 2006
GROUP BY C.MASP;

-- [37]
SELECT MONTH(NGHD) AS THANG,
       SUM(TRIGIA) AS DOANHTHU
FROM dbo.HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD);


-- [38]
SELECT C.SOHD,
       COUNT(C.MASP) AS SOSPKHACNHAU
FROM dbo.CTHD C
    INNER JOIN dbo.SANPHAM S
        ON S.MASP = C.MASP
GROUP BY C.SOHD
HAVING COUNT(C.MASP) >= 4;

-- [39]
SELECT C.SOHD
FROM CTHD C
    INNER JOIN dbo.SANPHAM S
        ON S.MASP = C.MASP
WHERE S.NUOCSX = 'Viet Nam'
GROUP BY C.SOHD
HAVING COUNT(DISTINCT C.MASP) = 3;

-- [40]
SELECT TOP 1
       MAKH,
       COUNT(SOHD) AS SL
FROM dbo.HOADON
GROUP BY MAKH
ORDER BY SL DESC;

-- [41]
SELECT TOP 1
       MONTH(NGHD) AS THANG,
       SUM(TRIGIA) AS DOANHTHU
FROM dbo.HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY DOANHTHU DESC;

-- [42]
SELECT TOP 1
       C.MASP,
       S.TENSP,
       SUM(C.SL) AS SOLUONG
FROM dbo.SANPHAM S
    INNER JOIN dbo.CTHD C
        ON C.MASP = S.MASP
    INNER JOIN dbo.HOADON H
        ON H.SOHD = C.SOHD
GROUP BY C.MASP,
         S.TENSP
ORDER BY SOLUONG ASC;

-- [43]
SELECT NUOCSX,
       MASP,
       TENSP,
       GIA
FROM dbo.SANPHAM AS SP
WHERE GIA =
(
    SELECT MAX(GIA)FROM dbo.SANPHAM WHERE NUOCSX = SP.NUOCSX GROUP BY NUOCSX
);

-- [44]
SELECT NUOCSX
FROM dbo.SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3;

-- [45]
SELECT TOP 1
       K.MAKH
FROM dbo.KHACHHANG K
    INNER JOIN dbo.HOADON H
        ON H.MAKH = K.MAKH
WHERE K.MAKH IN
      (
          SELECT TOP 10 MAKH FROM dbo.KHACHHANG ORDER BY DOANHSO DESC
      );

