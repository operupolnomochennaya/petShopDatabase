BEGIN;

DROP INDEX IF EXISTS idx_pet_owner;
DROP INDEX IF EXISTS idx_pet_petshop;
DROP INDEX IF EXISTS idx_emp_petshop;
DROP INDEX IF EXISTS idx_emp_cage;
DROP INDEX IF EXISTS idx_audit_pet;
DROP INDEX IF EXISTS idx_audit_changed;

DROP INDEX IF EXISTS gin_client_notes;
DROP INDEX IF EXISTS gin_employee_bio;
DROP INDEX IF EXISTS gin_pet_desc;

DROP INDEX IF EXISTS gin_pet_attr;
DROP INDEX IF EXISTS gin_client_pref;
DROP INDEX IF EXISTS gin_audit_diff;

DROP INDEX IF EXISTS gist_pet_stay;
DROP INDEX IF EXISTS gist_emp_years;
DROP INDEX IF EXISTS gist_petshop_loc;

DROP INDEX IF EXISTS pidx_pet_food_notnull;
DROP INDEX IF EXISTS pidx_client_notes_notnull;

COMMIT;