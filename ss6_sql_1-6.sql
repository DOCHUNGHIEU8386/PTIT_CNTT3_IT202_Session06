DROP DATABASE IF EXISTS ss6_mywork;
CREATE DATABASE ss6_mywork;
USE ss6_mywork;

-- =========================
-- BÀI 1: KHÁCH HÀNG & ĐƠN HÀNG
-- =========================

CREATE TABLE clients (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255)
);

CREATE TABLE sales_orders (
    id INT PRIMARY KEY,
    client_id INT NOT NULL,
    created_date DATE NOT NULL,
    order_status ENUM('pending','completed','cancelled'),
    total_price DECIMAL(10,2),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

INSERT INTO clients VALUES
(1,'Nguyễn Minh Đức','Hà Nội'),
(2,'Phạm Lan Anh','TP HCM'),
(3,'Trần Quốc Khánh','Đà Nẵng'),
(4,'Lê Thu Trang','Hải Phòng'),
(5,'Vũ Hoàng Nam','Cần Thơ');

INSERT INTO sales_orders VALUES
(201,1,'2025-12-01','completed',3600000),
(202,1,'2025-12-02','completed',4300000),
(203,1,'2025-12-03','completed',2500000),
(204,2,'2025-12-03','completed',5200000),
(205,3,'2025-12-04','pending',2000000),
(206,4,'2025-12-04','completed',1700000),
(207,1,'2025-12-05','completed',3000000);

-- =========================
-- BÀI 2: TỔNG TIỀN KHÁCH HÀNG
-- =========================

SELECT c.id, c.name, SUM(s.total_price) AS tong_chi
FROM clients c
JOIN sales_orders s ON c.id = s.client_id
GROUP BY c.id, c.name;

SELECT c.id, c.name, MAX(s.total_price) AS don_lon_nhat
FROM clients c
JOIN sales_orders s ON c.id = s.client_id
GROUP BY c.id, c.name;

-- =========================
-- BÀI 3: DOANH THU THEO NGÀY
-- =========================

SELECT created_date, SUM(total_price) AS doanh_thu
FROM sales_orders
WHERE order_status = 'completed'
GROUP BY created_date;

SELECT created_date, COUNT(id) AS so_don
FROM sales_orders
WHERE order_status = 'completed'
GROUP BY created_date;

SELECT created_date, SUM(total_price) AS doanh_thu
FROM sales_orders
WHERE order_status = 'completed'
GROUP BY created_date
HAVING doanh_thu > 10000000;

-- =========================
-- BÀI 4: SẢN PHẨM
-- =========================

CREATE TABLE items (
    id INT PRIMARY KEY,
    item_name VARCHAR(255),
    unit_price DECIMAL(10,2)
);

CREATE TABLE order_details (
    order_id INT,
    item_id INT,
    qty INT,
    PRIMARY KEY(order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES sales_orders(id),
    FOREIGN KEY (item_id) REFERENCES items(id)
);

INSERT INTO items VALUES
(1,'Điện thoại',7000000),
(2,'Tai nghe',800000),
(3,'Bàn phím',1200000),
(4,'Chuột',500000),
(5,'Màn hình',3500000);

INSERT INTO order_details VALUES
(201,1,1),
(201,2,2),
(202,5,1),
(203,4,2),
(204,1,1),
(206,3,1),
(207,2,3);

-- =========================
-- BÀI 5: KHÁCH HÀNG TIÊU BIỂU
-- =========================

SELECT c.id, c.name,
COUNT(s.id) AS tong_don,
SUM(s.total_price) AS tong_tien,
AVG(s.total_price) AS trung_binh
FROM clients c
JOIN sales_orders s ON c.id = s.client_id
WHERE s.order_status = 'completed'
GROUP BY c.id, c.name
HAVING tong_don >= 3 AND tong_tien > 10000000
ORDER BY tong_tien DESC;

-- =========================
-- BÀI 6: TOP SẢN PHẨM
-- =========================

SELECT i.item_name,
SUM(d.qty) AS tong_sl,
SUM(d.qty * i.unit_price) AS tong_doanh_thu,
AVG(i.unit_price) AS gia_tb
FROM items i
JOIN order_details d ON i.id = d.item_id
GROUP BY i.id, i.item_name
HAVING tong_sl >= 10
ORDER BY tong_doanh_thu DESC
LIMIT 5;
