INSERT INTO petshop(id, address, name, pets_capacity, city, location)
VALUES
  (1001, 'Test street 1', 'Test Shop 1', 50, 'Kazan', ST_SetSRID(ST_MakePoint(37.6,55.7),4326)::geography),
  (1002, 'Test street 2', 'Test Shop 2', 75, 'Moscow', ST_SetSRID(ST_MakePoint(37.7,55.8),4326)::geography)
ON CONFLICT (id) DO NOTHING;