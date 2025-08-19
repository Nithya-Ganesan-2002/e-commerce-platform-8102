-- Seed data for ecommerce_database (idempotent-safe inserts)

-- USERS
INSERT INTO users (id, email, password_hash, first_name, last_name, phone, role, is_active)
VALUES
  (1, 'alice@example.com', '$2b$12$examplehashalice', 'Alice', 'Anderson', '+1-202-555-0101', 'customer', 1),
  (2, 'bob@example.com',   '$2b$12$examplehashbob',   'Bob',   'Baker',    '+1-202-555-0102', 'customer', 1),
  (3, 'admin@example.com', '$2b$12$examplehashadmin', 'Admin', 'User',     NULL,               'admin',    1)
ON DUPLICATE KEY UPDATE
  email = VALUES(email);

-- PRODUCTS
INSERT INTO products (id, sku, name, slug, description, image_url, price_cents, currency, stock, category, is_active)
VALUES
  (1, 'SKU-TS-001', 'Basic T-Shirt', 'basic-t-shirt', 'Soft cotton t-shirt available in multiple colors', 'https://picsum.photos/seed/ts1/600/400', 1999, 'USD', 200, 'Apparel', 1),
  (2, 'SKU-JN-001', 'Blue Jeans', 'blue-jeans', 'Classic blue denim jeans', 'https://picsum.photos/seed/jn1/600/400', 4999, 'USD', 150, 'Apparel', 1),
  (3, 'SKU-SN-001', 'Running Sneakers', 'running-sneakers', 'Lightweight sneakers for running', 'https://picsum.photos/seed/sn1/600/400', 7999, 'USD', 120, 'Footwear', 1),
  (4, 'SKU-HS-001', 'Wireless Headset', 'wireless-headset', 'Over-ear wireless Bluetooth headset', 'https://picsum.photos/seed/hs1/600/400', 12999, 'USD', 75, 'Electronics', 1),
  (5, 'SKU-MG-001', 'Coffee Mug', 'coffee-mug', 'Ceramic mug 12oz with matte finish', 'https://picsum.photos/seed/mg1/600/400', 1299, 'USD', 300, 'Home', 1)
ON DUPLICATE KEY UPDATE
  sku = VALUES(sku), name = VALUES(name), slug = VALUES(slug);

-- CARTS (active carts for users 1 and 2)
INSERT INTO carts (id, user_id, status)
VALUES
  (1, 1, 'active'),
  (2, 2, 'active')
ON DUPLICATE KEY UPDATE
  status = VALUES(status);

-- CART_ITEMS
INSERT INTO cart_items (id, cart_id, product_id, quantity, unit_price_cents)
VALUES
  (1, 1, 1, 2, 1999),
  (2, 1, 5, 1, 1299),
  (3, 2, 3, 1, 7999)
ON DUPLICATE KEY UPDATE
  quantity = VALUES(quantity), unit_price_cents = VALUES(unit_price_cents);

-- ORDERS
INSERT INTO orders (
  id, user_id, cart_id, order_number, status,
  subtotal_cents, tax_cents, shipping_cents, discount_cents, total_cents,
  currency, payment_method, payment_reference, shipping_address, billing_address, placed_at
)
VALUES
  (
    1, 1, 1, 'ORD-1001', 'paid',
    1999*2 + 1299, 399, 599, 0, (1999*2 + 1299 + 399 + 599),
    'USD', 'card', 'pm_12345',
    JSON_OBJECT('name','Alice Anderson','line1','123 Market St','city','Metropolis','region','CA','postal','94016','country','US'),
    JSON_OBJECT('name','Alice Anderson','line1','123 Market St','city','Metropolis','region','CA','postal','94016','country','US'),
    CURRENT_TIMESTAMP
  ),
  (
    2, 2, 2, 'ORD-1002', 'pending',
    7999, 160, 599, 0, (7999 + 160 + 599),
    'USD', 'card', NULL,
    JSON_OBJECT('name','Bob Baker','line1','456 Center Rd','city','Gotham','region','NY','postal','10001','country','US'),
    JSON_OBJECT('name','Bob Baker','line1','456 Center Rd','city','Gotham','region','NY','postal','10001','country','US'),
    CURRENT_TIMESTAMP
  )
ON DUPLICATE KEY UPDATE
  status = VALUES(status), total_cents = VALUES(total_cents);

-- ORDER_ITEMS
INSERT INTO order_items (id, order_id, product_id, product_name, sku, quantity, unit_price_cents, total_price_cents)
VALUES
  (1, 1, 1, 'Basic T-Shirt', 'SKU-TS-001', 2, 1999, 2*1999),
  (2, 1, 5, 'Coffee Mug', 'SKU-MG-001', 1, 1299, 1299),
  (3, 2, 3, 'Running Sneakers', 'SKU-SN-001', 1, 7999, 7999)
ON DUPLICATE KEY UPDATE
  quantity = VALUES(quantity), total_price_cents = VALUES(total_price_cents);
