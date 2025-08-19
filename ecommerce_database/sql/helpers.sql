-- Useful helper queries for local development

-- List users
SELECT id, email, role, is_active, created_at FROM users ORDER BY id;

-- List products with stock
SELECT id, sku, name, price_cents, currency, stock, category, is_active FROM products ORDER BY id;

-- Show current carts and their totals
SELECT cart_id, user_id, SUM(quantity * unit_price_cents) AS subtotal_cents
FROM v_cart_contents
GROUP BY cart_id, user_id
ORDER BY cart_id;

-- Recent orders
SELECT order_id, email, status, total_cents, currency, placed_at
FROM v_user_orders
ORDER BY order_id DESC
LIMIT 20;
