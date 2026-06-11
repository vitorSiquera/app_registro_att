const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production'
    ? { rejectUnauthorized: false }
    : false,
});

async function initDatabase() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS atividades (
      id SERIAL PRIMARY KEY,
      nome TEXT NOT NULL,
      tipo TEXT NOT NULL,
      duracao_minutos INTEGER NOT NULL,
      calorias INTEGER NOT NULL,
      intensidade TEXT NOT NULL,
      data TEXT NOT NULL
    )
  `);
}

module.exports = { pool, initDatabase };
