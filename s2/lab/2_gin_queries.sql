EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM pet
WHERE attributes @> '{"color":"black"}'::jsonb;

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM client
WHERE preferences ? 'newsletter';

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM audit_pet_accessorie
WHERE diff @> '{"reason":"sale"}'::jsonb;

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM pet
WHERE tags && ARRAY['cute','active'];

EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM pet
WHERE description_tsv @@ plainto_tsquery('simple', 'pet description');