# Project Repository

This is the initial README file for the project.

## Database (ecommerce_database)

See ecommerce_database/ for schema and seed. Quick start:

- Start MySQL (if not already running):
  (from ecommerce_database)
  ./startup.sh

- Apply schema and seed:
  ./migrations/run_migrations.sh

- Connection:
  See ecommerce_database/db_connection.txt
  Or source ecommerce_database/db_visualizer/mysql.env for tooling that relies on env vars.