PRAGMA foreign_keys = ON;

CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
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

-- The "product rules", indcating which options are allowed on which door models.
CREATE TABLE model_options (
  model_id INTEGER NOT NULL REFERENCES door_models(id),
  option_id INTEGER NOT NULL REFERENCES options(id),
  PRIMARY KEY (model_id, option_id)
);

CREATE TABLE quotes (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES customers(id),
  -- status will be used to follow a quote's life: draft -> submitted -> synced (synced to fake CRM) or failed.
  status TEXT NOT NULL DEFAULT 'draft' 
    CHECK (status IN ('draft', 'submitted', 'synced', 'failed')),
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quote_items (
  id INTEGER PRIMARY KEY,
  quote_id INTEGER NOT NULL REFERENCES quotes(id),
  model_id INTEGER NOT NULL REFERENCES door_models(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  -- unit_price will be the total price for this item, including the base price of the model and any options.
  -- unit_price is a snapshot of the price at the time of quote creation, so it doesn't change if the model's base price or option prices change later.
  unit_price REAL NOT NULL
);

CREATE TABLE quote_item_options (
  quote_item_id INTEGER NOT NULL REFERENCES quote_items(id),
  option_id INTEGER NOT NULL REFERENCES options(id),
  price_change REAL NOT NULL, 
  -- price_change snapshotted at time of quote creation--does not change if the option's price_change changes later.
  PRIMARY KEY (quote_item_id, option_id)
);

-- sync_log will be used to track attempts to sync quotes to the fake CRM, one row per attempt.
-- It will record, what happened, the HTTP status code, any error, and the exact JSON sent.
CREATE TABLE sync_log (
  id INTEGER PRIMARY KEY,
  quote_id INTEGER NOT NULL REFERENCES quotes(id),
  attempted_at TEXT DEFAULT CURRENT_TIMESTAMP,
  outcome TEXT NOT NULL CHECK (outcome IN ('success','failure')),
  http_status INTEGER,
  error_message TEXT,
  payload TEXT -- the JSON that was sent
);