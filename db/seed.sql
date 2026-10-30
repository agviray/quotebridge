-- Sample data for the QuoteBridge database. This file is intended to be run after the schema.sql file, and will fill the database with some example data.
INSERT INTO customers (id, name, email) VALUES 
  (1, 'Maria Alvarez', 'maria@alvarezbuild.example'),
  (2, 'James Okafor', 'james@okaforhomes.example'),
  (3, 'Priya Nair',    'priya@nairdesign.example'),
  (4, 'Tom Becker',    NULL), -- no email on purpose
  (5, 'Linda Cho',     'linda@choremodel.example'),
  (6, 'L. Cho',        'linda@choremodel.example'),-- duplicate email on purpose
  (7, 'Derek Hall',    'derek@hallcustom.example'),
  (8, 'Sofia Reyes',   'sofia@reyesroofing.example');

  INSERT INTO door_models (id, name, material, base_price) VALUES
  (1, 'Aspen',       'wood',      1450),
  (2, 'Cedar Ridge', 'wood',      1890),
  (3, 'Harbor',      'composite', 1250),
  (4, 'Summit',      'composite', 1620),
  (5, 'Sentinel',    'steel',      980);

  INSERT INTO options (id, category, name, price_delta) VALUES
  (1,  'glass',    'Clear beveled glass',        220),
  (2,  'glass',    'Frosted glass',              260),
  (3,  'glass',    'Decorative leaded glass',    480),
  (4,  'finish',   'Natural stain',              150),
  (5,  'finish',   'Painted white',               90),
  (6,  'finish',   'Painted black',               90),
  (7,  'hardware', 'Brushed nickel handleset',   120),
  (8,  'hardware', 'Oil-rubbed bronze handleset',140),
  (9,  'hardware', 'Smart lock',                 310),
  (10, 'finish',   'Dark walnut stain',          190);

-- The allowed options per model (the "product rules").
-- Wood: glass, stains, hardware, Composite: glass, paint, hardware, Steel: paint and hardware only (no glass, no stain).
INSERT INTO model_options (model_id, option_id) VALUES
  (1,1),(1,2),(1,3),(1,4),(1,10),(1,7),(1,8),(1,9),
  (2,1),(2,2),(2,3),(2,4),(2,10),(2,7),(2,8),(2,9),
  (3,1),(3,2),(3,5),(3,6),(3,7),(3,8),(3,9),
  (4,1),(4,2),(4,3),(4,5),(4,6),(4,7),(4,8),(4,9),
  (5,5),(5,6),(5,7),(5,8),(5,9);

INSERT INTO quotes (id, customer_id, status) VALUES
  (1, 1, 'submitted'),
  (2, 2, 'draft'),
  (3, 3, 'submitted'),
  (4, 4, 'submitted'), -- Customer has no email: this one will fail to sync
  (5, 5, 'draft'), -- Empty quote on purpose (see quote_items showing no items)
  (6, 7, 'draft'); -- Contains a rule violation on purpose (glass on a steel door)

INSERT INTO quote_items (id, quote_id, model_id, quantity, unit_price) VALUES 
  (1, 1, 1, 1, 1940), -- Aspen 1450 + 220 + 150 + 120
  (2, 2, 3, 2, 1480), -- Harbor 1250 + 90 + 140
  (3, 3, 5, 3, 1380), -- Sentinel 980 + 90 + 310
  (4, 4, 4, 1, 1970), -- Summit 1620 + 260 + 90
  (5, 6, 5, 1, 1200); -- Sentinel 980 + 220 (clear glass is NOT allowed on steel)

INSERT INTO quote_item_options (quote_item_id, option_id, price_change) VALUES
  (1, 1, 220), (1, 4, 150), (1, 7, 120),
  (2, 5, 90),  (2, 8, 140),
  (3, 6, 90),  (3, 9, 310),
  (4, 2, 260), (4, 5, 90),
  (5, 1, 220);