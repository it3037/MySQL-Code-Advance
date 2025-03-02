create database E_Commerce_System;
use E_Commerce_System;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO customers (name, email, phone, city) VALUES
('Amit Sharma', 'amit@example.com', '9876543210', 'Delhi'),
('Riya Verma', 'riya@example.com', '9823456789', 'Mumbai'),
('Vikas Singh', 'vikas@example.com', '9898765432', 'Bangalore'),
('Neha Jain', 'neha@example.com', '9765432198', 'Pune'),
('Rahul Gupta', 'rahul@example.com', '9654321876', 'Hyderabad'),
('Anita Roy', 'anita@example.com', '9988776655', 'Chennai'),
('Suresh Mehta', 'suresh@example.com', '9876543201', 'Kolkata'),
('Priya Das', 'priya@example.com', '9765412345', 'Ahmedabad'),
('Arun Nair', 'arun@example.com', '9654321098', 'Jaipur'),
('Swati Mishra', 'swati@example.com', '9854321765', 'Lucknow');

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    category VARCHAR(50)
);

INSERT INTO products (product_name, price, stock, category) VALUES
('Laptop', 55000.00, 10, 'Electronics'),
('Smartphone', 25000.00, 15, 'Electronics'),
('Headphones', 3000.00, 30, 'Accessories'),
('Gaming Console', 45000.00, 5, 'Gaming'),
('Washing Machine', 35000.00, 8, 'Home Appliances'),
('Refrigerator', 40000.00, 6, 'Home Appliances'),
('Smart Watch', 12000.00, 20, 'Accessories'),
('Tablet', 22000.00, 12, 'Electronics'),
('Bluetooth Speaker', 5000.00, 25, 'Accessories'),
('LED TV', 60000.00, 7, 'Electronics');

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO orders (customer_id, product_id, quantity, status) VALUES
(1, 2, 1, 'Delivered'),
(2, 5, 1, 'Shipped'),
(3, 1, 2, 'Pending'),
(4, 4, 1, 'Delivered'),
(5, 3, 3, 'Cancelled'),
(6, 7, 1, 'Shipped'),
(7, 6, 1, 'Pending'),
(8, 9, 2, 'Delivered'),
(9, 10, 1, 'Shipped'),
(10, 8, 1, 'Cancelled');

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(20) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'Net Banking', 'UPI', 'Cash on Delivery')),
    payment_status VARCHAR(20) CHECK (payment_status IN ('Paid', 'Pending', 'Failed')),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
INSERT INTO payments (order_id, amount, payment_method, payment_status) VALUES
(1, 25000.00, 'Credit Card', 'Paid'),
(2, 35000.00, 'Net Banking', 'Paid'),
(3, 110000.00, 'UPI', 'Pending'),
(4, 45000.00, 'Debit Card', 'Paid'),
(5, 9000.00, 'Cash on Delivery', 'Failed'),
(6, 12000.00, 'UPI', 'Paid'),
(7, 40000.00, 'Credit Card', 'Pending'),
(8, 10000.00, 'Net Banking', 'Paid'),
(9, 60000.00, 'Debit Card', 'Paid'),
(10, 22000.00, 'Cash on Delivery', 'Failed');

select * from customers;
select * from orders;
select * from payments;
select * from products;
select c.name,c.city,o.order_id,year(o.order_date),p.product_name,p.stock,p.category,pay.amount,pay.payment_status,pay.payment_method
from customers c
left join orders o on c.customer_id=o.customer_id
left join products p on o.product_id=p.product_id
left join payments pay on o.order_id=pay.order_id
where payment_status='Paid';

select c.name,c.city,o.order_id,o.order_date,p.product_name,p.price,pay.amount,pay.payment_status
from customers c
right join orders o on c.customer_id=o.customer_id
right join products p on o.product_id=p.product_id
right join payments pay on o.order_id=pay.order_id
where payment_status='Paid';

create index idx_customer_id on orders(customer_id);
create index idx_product_id on products(product_id);
SHOW INDEX FROM products WHERE Key_name = 'idx_product_id';
SELECT * 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_NAME = 'products' AND INDEX_NAME = 'idx_product_id';

SHOW INDEX FROM products;

