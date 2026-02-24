BEGIN;

INSERT INTO petshop(address, name, pets_capacity, city, location)
SELECT
  'Street ' || gs,
  'Shop #' || gs,
  (100 + (random()*900)::int),
  (ARRAY['Moscow','Kazan','Perm','Samara','Ufa'])[1 + (random()*4)::int],
  ST_SetSRID(ST_MakePoint(37 + random(), 55 + random()), 4326)::geography
FROM generate_series(1,100) gs;

INSERT INTO animal_type(name)
SELECT x FROM (VALUES ('dog'),('cat'),('parrot'),('hamster'),('fish'),('rabbit')) v(x);

INSERT INTO breed(breed_name, animal_type_id, average_weight)
SELECT
  'Breed_'||gs,
  1 + (random()*5)::int,
  round((1 + random()*40)::numeric, 2)
FROM generate_series(1,200) gs;

INSERT INTO food(brand_name, food_type)
SELECT
  'Brand_'||gs,
  (ARRAY['dry','wet','mix','premium','diet'])[1 + (random()*4)::int]
FROM generate_series(1,50) gs;

INSERT INTO accessorie(name)
SELECT 'Acc_'||gs FROM generate_series(1,200) gs;

INSERT INTO medication(name)
SELECT 'Med_'||gs FROM generate_series(1,100) gs;

INSERT INTO cage(animal_type_id, petshop_id, current_pet_id)
SELECT
  1 + (random()*5)::int,
  1 + (random()*99)::int,
  NULL
FROM generate_series(1,5000);

COMMIT;
