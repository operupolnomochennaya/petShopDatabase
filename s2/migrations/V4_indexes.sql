BEGIN;

CREATE INDEX IF NOT EXISTS idx_pet_owner     ON pet(owner_id);
CREATE INDEX IF NOT EXISTS idx_pet_petshop   ON pet(petshop_id);
CREATE INDEX IF NOT EXISTS idx_emp_petshop   ON employee(petshop_id);
CREATE INDEX IF NOT EXISTS idx_emp_cage      ON employee(cage_id);
CREATE INDEX IF NOT EXISTS idx_audit_pet     ON audit_pet_accessorie(pet_id);
CREATE INDEX IF NOT EXISTS idx_audit_changed ON audit_pet_accessorie(changed_at);

CREATE INDEX IF NOT EXISTS gin_client_notes ON client USING GIN (notes_tsv);
CREATE INDEX IF NOT EXISTS gin_employee_bio ON employee USING GIN (bio_tsv);
CREATE INDEX IF NOT EXISTS gin_pet_desc     ON pet USING GIN (description_tsv);

CREATE INDEX IF NOT EXISTS gin_pet_attr     ON pet USING GIN (attributes);
CREATE INDEX IF NOT EXISTS gin_client_pref  ON client USING GIN (preferences);
CREATE INDEX IF NOT EXISTS gin_audit_diff   ON audit_pet_accessorie USING GIN (diff);

CREATE INDEX IF NOT EXISTS gist_pet_stay    ON pet USING GIST (stay);
CREATE INDEX IF NOT EXISTS gist_emp_years   ON employee USING GIST (work_years);

CREATE INDEX IF NOT EXISTS gist_petshop_loc ON petshop USING GIST (location);

CREATE INDEX IF NOT EXISTS pidx_pet_food_notnull ON pet(food_id) WHERE food_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS pidx_client_notes_notnull ON client(id) WHERE notes IS NOT NULL;

COMMIT;
