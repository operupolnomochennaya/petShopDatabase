BEGIN;

INSERT INTO client(name, surname, passport_data, segment, preferences, phones, notes)
SELECT
  'Name_' || gs,
  'Surname_' || gs,
  encode(gen_random_bytes(10), 'hex'), 
  (ARRAY['A','B','C','D'])[1 + floor(random()*4)::int], 
  jsonb_build_object(
    'newsletter', (random() > 0.5),
    'fav_animals', (ARRAY['dog','cat','fish','rabbit'])[1 + floor(random()*4)::int],
    'score', floor(random()*101)::int
  ),
  ARRAY[
    '+7' || (1000000000 + floor(random()*9000000000)::bigint)::text
  ],
  CASE
    WHEN random() < 0.15 THEN NULL                
    ELSE ('client note ' || md5(gs::text))
  END
FROM generate_series(1,250000) gs;

INSERT INTO employee(name, surname, profession, cage_id, petshop_id, meta, skills, work_years, bio)
SELECT
  'EmpName_' || gs,
  'EmpSur_'  || gs,
  (ARRAY['seller','manager','vet','groomer','cashier'])[1 + floor(random()*5)::int], 
  CASE
    WHEN random() < 0.10 THEN NULL              
    ELSE 1 + floor(random()*5000)::int          
  END,
  CASE
    WHEN random() < 0.70 THEN 1 + floor(random()*10)::int  
    ELSE 11 + floor(random()*90)::int                      
  END,
  jsonb_build_object(
    'shift', (ARRAY['day','night'])[1 + floor(random()*2)::int],
    'rating', round((random()*5)::numeric, 2)
  ),
  ARRAY[
    (ARRAY['sales','care','docs','it','logistics'])[1 + floor(random()*5)::int],
    (ARRAY['english','excel','powerbi','crm','kpi'])[1 + floor(random()*5)::int]
  ],
  int4range(
    floor(random()*10)::int,
    (10 + floor(random()*20))::int,
    '[]'
  ),
  CASE
    WHEN random() < 0.12 THEN NULL              
    ELSE ('employee bio ' || md5(gs::text))
  END
FROM generate_series(1,250000) gs;

INSERT INTO pet(name, age, owner_id, breed_id, food_id, petshop_id, status, attributes, tags, stay, description)
SELECT
  'Pet_' || gs,
  floor(random()*19)::int,                       
  1 + floor(random()*250000)::int,               
  1 + floor(random()*200)::int,                  
  CASE
    WHEN random() < 0.20 THEN NULL              
    ELSE 1 + floor(random()*50)::int             
  END,
  CASE
    WHEN random() < 0.70 THEN 1 + floor(random()*10)::int  
    ELSE 11 + floor(random()*90)::int
  END,
  (ARRAY['new','healthy','sick','adopted'])[1 + floor(random()*4)::int], 
  jsonb_build_object(
    'color', (ARRAY['black','white','brown','mix'])[1 + floor(random()*4)::int],
    'chip', encode(gen_random_bytes(6), 'hex'),
    'vaccinated', (random() > 0.3)
  ),
  ARRAY[
    (ARRAY['cute','aggressive','calm','active','sleepy'])[1 + floor(random()*5)::int]
  ],
  tsrange(
    (now()::timestamp) - (floor(random()*181)::int || ' days')::interval,
    (now()::timestamp) + (floor(random()*31)::int  || ' days')::interval,
    '[]'
  ),
  CASE
    WHEN random() < 0.10 THEN NULL            
    ELSE ('pet description ' || md5(gs::text))
  END
FROM generate_series(1,250000) gs;

INSERT INTO audit_pet_accessorie(changed_at, action, username, pet_id, accessorie_id, old_amount, new_amount, diff, flags)
SELECT
  now() - (floor(random()*366)::int || ' days')::interval,
  (ARRAY['insert','update','delete'])[1 + floor(random()*3)::int], 
  'user_' || gs,                                
  1 + floor(random()*250000)::int,                
  1 + floor(random()*200)::int,                   
  CASE
    WHEN random() < 0.10 THEN NULL               
    ELSE floor(random()*11)::int                  
  END,
  floor(random()*11)::int,                   
  jsonb_build_object(
    'reason', (ARRAY['sale','lost','broken','promo'])[1 + floor(random()*4)::int],
    'batch',  floor(random()*1000)::int
  ),
  ARRAY[
    (ARRAY['ok','manual','bulk','import'])[1 + floor(random()*4)::int]
  ]
FROM generate_series(1,250000) gs;

COMMIT;

ANALYZE;