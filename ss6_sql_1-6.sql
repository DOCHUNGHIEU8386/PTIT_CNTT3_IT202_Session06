DROP DATABASE IF EXISTS ss6_mywork;
CREATE DATABASE ss6_mywork;
USE ss6_mywork;

-- BAI 1: KHACH HANG & DON HANG
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
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

INSERT INTO clients VALUES
(1,'Nguyễn Minh Đức','Hà Nội'),
(2,'Phạm Lan Anh','TP HCM'),
(3,'Trần Quốc Khánh','Đà Nẵng'),
(4,'Lê Thu Trang','Hải Phòng'),
(5,'Vũ Hoàng Nam','Cần Thơ');

INSERT INTO sales_orders VALUES
(201,1,'2025-12-01','completed'),
(202,1,'2025-12-02','completed'),
(203,1,'2025-12-03','completed'),
(204,2,'2025-12-03','completed'),
(205,3,'2025-12-04','pending'),
(206,4,'2025-12-04','completed'),
(207,1,'2025-12-05','completed');

ALTER TABLE sales_orders ADD total_price DECIMAL(10,2);

UPDATE sales_orders SET total_price = 3600000 WHERE id = 201;
UPDATE sales_orders SET total_price = 4300000 WHERE id = 202;
UPDATE sales_orders SET total_price = 2500000 WHERE id = 203;
UPDATE sales_orders SET total_price = 5200000 WHERE id = 204;
UPDATE sales_orders SET total_price = 2000000 WHERE id = 205;
UPDATE sales_orders SET total_price = 1700000 WHERE id = 206;
UPDATE sales_orders SET total_price = 3000000 WHERE id = 207;

-- BAI 4: SAN PHAM
CREATE TABLE items (
    id INT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    unit_price DECIMAL(10,2) CHECK (unit_price > 0)
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
