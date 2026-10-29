PRAGMA foreign_keys = ON;

CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT,
  email TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE door_models (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  material TEXT NOT NULL CHECK (material IN ('wood', 'composite', 'steel')),
  base_price REAL NOT NULL CHECK (base_price > 0)
);

CREATE TABLE options (
  id INTEGER PRIMARY KEY,
  category TEXT NOT NULL, -- Maybe something like 'glass', 'finish', or 'hardware'.
  name TEXT NOT NULL,
  price_change REAL NOT NULL DEFAULT 0 -- How much an option adds to the price.
);