const fs = require('fs').promises;
const path = require('path');

async function initializeDatabase(pool) {
  try {
    console.log('Initializing database...');
    const initSql = await fs.readFile(path.join(__dirname, '../init.sql'), 'utf8');
    await pool.query(initSql);
    console.log('Database initialization complete');
  } catch (error) {
    console.error('Error initializing database:', error);
    throw error;
  }
}

module.exports = { initializeDatabase };