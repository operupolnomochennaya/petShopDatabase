EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM pet
WHERE stay @> now()::timestamp;

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM pet
WHERE stay && tsrange(
  now()::timestamp - interval '7 days',
  now()::timestamp + interval '7 days',
  '[]'
);

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM employee
WHERE work_years @> 5;

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM employee
WHERE work_years && int4range(3, 8, '[]');

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM petshop
WHERE ST_DWithin(
  location,
  ST_SetSRID(ST_MakePoint(37.6, 55.7), 4326)::geography,
  50000
);