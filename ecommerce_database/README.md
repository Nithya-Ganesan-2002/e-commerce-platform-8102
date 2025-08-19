# ecommerce_database (MySQL)

This container provides the MySQL schema and seed data for the e-commerce application, including users, products, carts, orders, and related items.

## What’s included

- SQL DDL (schema.sql) for:
  - users, products, carts, cart_items, orders, order_items
  - helpful views: v_user_orders, v_cart_contents
  - indexes, constraints, and sensible defaults
- Seed data (seed.sql) for initial testing
- Migration runner (migrations/run_migrations.sh)
- Local MySQL bootstrapper (startup.sh) which also writes db_visualizer/mysql.env

## Environment variables

The platform defines (already present via startup.sh and db_visualizer/mysql.env):

- MYSQL_URL
- MYSQL_USER
- MYSQL_PASSWORD
- MYSQL_DB
- MYSQL_PORT

For direct MySQL CLI and migrations, you can also set:

- MYSQL_HOST (defaults to 127.0.0.1)

Do NOT commit real secrets. For deployment, these variables will be provided by the environment. You may create a .env.example in upper layers if needed.

## Local usage

1) Start or ensure MySQL is running (startup.sh can help on some environments):
   ./startup.sh

2) Apply schema and seed:
   ./migrations/run_migrations.sh

3) Connection info:
   - CLI: See `db_connection.txt`
   - Visualizer: source db_visualizer/mysql.env; then run the Node viewer in db_visualizer (optional utility).

## Integration with backend

The ecommerce_backend container should use the following envs:

- MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB, MYSQL_PORT

Example Node.js (mysql2 / Sequelize / Knex) minimal config:

```javascript
// PUBLIC_INTERFACE
function getMySqlConfigFromEnv(env = process.env) {
  /** Returns a plain object suitable for mysql2/knex/sequelize from environment variables. */
  const url = env.MYSQL_URL || '';
  const host = (url && url.includes('://')) ? url.split('://')[1].split('/')[0].split(':')[0] : (env.MYSQL_HOST || '127.0.0.1');
  const port = Number((url && url.includes('://')) ? (url.split(':')[2] || '').split('/')[0] : (env.MYSQL_PORT || 3306));
  return {
    host,
    port: Number.isFinite(port) && port > 0 ? port : Number(env.MYSQL_PORT || 3306),
    user: env.MYSQL_USER,
    password: env.MYSQL_PASSWORD,
    database: env.MYSQL_DB
  };
}
module.exports = { getMySqlConfigFromEnv };
```

The schema stores prices in cents and enforces referential integrity.

## Tables overview

- users: account data (email unique, bcrypt-like hash stored in password_hash, role, active flags)
- products: catalog with SKU/slug uniqueness, stock, category, and active flag
- carts: one active cart per user enforced by (user_id, status) uniqueness
- cart_items: quantity > 0, snapshot unit price
- orders: totals in cents, status lifecycle, addresses as JSON
- order_items: denormalized product snapshot for historical accuracy

## Notes

- The provided seed passwords are placeholder hashes (not real bcrypt). Replace during integration if necessary.
- If you use Sequelize/Knex/TypeORM, point to the same env vars.
