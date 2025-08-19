'use strict';

/**
 * PUBLIC_INTERFACE
 * getMySqlConfigFromEnv
 * Returns a plain object suitable for mysql2/knex/sequelize from environment variables.
 */
function getMySqlConfigFromEnv(env = process.env) {
  /** This is a public function. */
  const url = env.MYSQL_URL || '';
  let hostFromUrl = null;
  let portFromUrl = null;

  if (url && url.includes('://')) {
    try {
      const afterProto = url.split('://')[1];
      const hostPort = afterProto.split('/')[0];
      const parts = hostPort.split(':');
      hostFromUrl = parts[0] || null;
      portFromUrl = parts[1] ? Number(parts[1]) : null;
    } catch {
      // ignore parsing errors and fall back to explicit vars
    }
  }

  const host = hostFromUrl || env.MYSQL_HOST || '127.0.0.1';
  const port = Number.isFinite(portFromUrl) && portFromUrl > 0 ? portFromUrl : Number(env.MYSQL_PORT || 3306);

  return {
    host,
    port,
    user: env.MYSQL_USER,
    password: env.MYSQL_PASSWORD,
    database: env.MYSQL_DB
  };
}

module.exports = { getMySqlConfigFromEnv };
