SELECT
  p.id,
  p.name AS pet_name,
  c.name AS owner_name,
  c.surname AS owner_surname
FROM pet p
JOIN client c ON c.id = p.owner_id
LIMIT 20;

SELECT
  p.id,
  p.name,
  b.breed_name,
  at.name AS animal_type
FROM pet p
JOIN breed b ON b.id = p.breed_id
JOIN animal_type at ON at.id = b.animal_type_id
LIMIT 20;

SELECT
  e.id,
  e.name,
  e.surname,
  e.profession,
  e.cage_id,
  ps.name AS petshop_name
FROM employee e
LEFT JOIN cage c ON c.id = e.cage_id
JOIN petshop ps ON ps.id = e.petshop_id
LIMIT 20;

SELECT
  p.id,
  p.name,
  f.brand_name,
  f.food_type,
  ps.name AS petshop_name
FROM pet p
LEFT JOIN food f ON f.id = p.food_id
JOIN petshop ps ON ps.id = p.petshop_id
LIMIT 20;

SELECT
  pa.pet_id,
  p.name AS pet_name,
  a.name AS accessory_name,
  pa.amount
FROM pet_accessorie pa
JOIN pet p ON p.id = pa.pet_id
JOIN accessorie a ON a.id = pa.accessorie_id
LIMIT 20;