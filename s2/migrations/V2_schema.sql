BEGIN;

CREATE TABLE IF NOT EXISTS petshop (
  id              bigserial PRIMARY KEY,
  address         text NOT NULL,
  name            text NOT NULL,
  pets_capacity   int NOT NULL CHECK (pets_capacity > 0),
  -- геометрия: точка магазина
  location        geography(Point, 4326),
  -- низкая кардинальность (3-5 значений)
  city            text NOT NULL
);

CREATE TABLE IF NOT EXISTS animal_type (
  id    bigserial PRIMARY KEY,
  name  text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS breed (
  id              bigserial PRIMARY KEY,
  breed_name      text NOT NULL,
  animal_type_id  bigint NOT NULL REFERENCES animal_type(id),
  average_weight  numeric(6,2)
);

CREATE TABLE IF NOT EXISTS food (
  id          bigserial PRIMARY KEY,
  brand_name  text NOT NULL,
  food_type   text NOT NULL
);

CREATE TABLE IF NOT EXISTS accessorie (
  id    bigserial PRIMARY KEY,
  name  text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS medication (
  id    bigserial PRIMARY KEY,
  name  text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS cage (
  id              bigserial PRIMARY KEY,
  animal_type_id  bigint NOT NULL REFERENCES animal_type(id),
  petshop_id      bigint NOT NULL REFERENCES petshop(id),
  current_pet_id  bigint
);

CREATE TABLE IF NOT EXISTS client (
  id             bigserial PRIMARY KEY,
  name           text NOT NULL,
  surname        text NOT NULL,
  passport_data  text NOT NULL UNIQUE,      
  segment        text NOT NULL CHECK (segment IN ('A','B','C','D')),
  preferences    jsonb,
  phones         text[],
  notes          text,
  notes_tsv      tsvector
);

CREATE TABLE IF NOT EXISTS employee (
  id          bigserial PRIMARY KEY,
  name        text NOT NULL,
  surname     text NOT NULL,
  profession  text NOT NULL,                       
  cage_id     bigint REFERENCES cage(id),
  petshop_id  bigint NOT NULL REFERENCES petshop(id), 
  meta        jsonb,
  skills      text[],
  work_years  int4range,
  bio         text,
  bio_tsv     tsvector
);

CREATE TABLE IF NOT EXISTS pet (
  id         bigserial PRIMARY KEY,
  name       text NOT NULL,                          
  age        int NOT NULL CHECK (age >= 0),
  owner_id   bigint NOT NULL REFERENCES client(id),
  breed_id   bigint NOT NULL REFERENCES breed(id),
  food_id    bigint REFERENCES food(id),
  petshop_id bigint NOT NULL REFERENCES petshop(id),  
  status     text NOT NULL CHECK (status IN ('new','healthy','sick','adopted')),
  attributes jsonb,
  tags       text[],
  stay       tsrange,
  description text,
  description_tsv tsvector
);

CREATE TABLE IF NOT EXISTS pet_accessorie (
  pet_id        bigint NOT NULL REFERENCES pet(id) ON DELETE CASCADE,
  accessorie_id bigint NOT NULL REFERENCES accessorie(id),
  amount        int NOT NULL CHECK (amount >= 0),
  PRIMARY KEY (pet_id, accessorie_id)
);

CREATE TABLE IF NOT EXISTS pet_medication (
  pet_id        bigint NOT NULL REFERENCES pet(id) ON DELETE CASCADE,
  medication_id bigint NOT NULL REFERENCES medication(id),
  PRIMARY KEY (pet_id, medication_id)
);

CREATE TABLE IF NOT EXISTS audit_pet_accessorie (
  audit_id      bigserial PRIMARY KEY,
  changed_at    timestamptz NOT NULL,
  action        text NOT NULL CHECK (action IN ('insert','update','delete')),
  username      text NOT NULL,                        
  pet_id        bigint NOT NULL REFERENCES pet(id) ON DELETE CASCADE,
  accessorie_id bigint NOT NULL REFERENCES accessorie(id),
  old_amount    int,
  new_amount    int,
  diff          jsonb,
  flags         text[]
);

CREATE OR REPLACE FUNCTION fts_update_client() RETURNS trigger AS $$
BEGIN
  NEW.notes_tsv :=
    to_tsvector('simple', unaccent(coalesce(NEW.notes,'')));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fts_update_employee() RETURNS trigger AS $$
BEGIN
  NEW.bio_tsv :=
    to_tsvector('simple', unaccent(coalesce(NEW.bio,'')));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fts_update_pet() RETURNS trigger AS $$
BEGIN
  NEW.description_tsv :=
    to_tsvector('simple', unaccent(coalesce(NEW.description,'')));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_client_fts ON client;
CREATE TRIGGER trg_client_fts BEFORE INSERT OR UPDATE ON client
FOR EACH ROW EXECUTE FUNCTION fts_update_client();

DROP TRIGGER IF EXISTS trg_employee_fts ON employee;
CREATE TRIGGER trg_employee_fts BEFORE INSERT OR UPDATE ON employee
FOR EACH ROW EXECUTE FUNCTION fts_update_employee();

DROP TRIGGER IF EXISTS trg_pet_fts ON pet;
CREATE TRIGGER trg_pet_fts BEFORE INSERT OR UPDATE ON pet
FOR EACH ROW EXECUTE FUNCTION fts_update_pet();

COMMIT;
