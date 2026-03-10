DROP INDEX IF EXISTS gin_lab_pet_attr;
DROP INDEX IF EXISTS gin_lab_client_pref;
DROP INDEX IF EXISTS gin_lab_audit_diff;
DROP INDEX IF EXISTS gin_lab_pet_tags;
DROP INDEX IF EXISTS gin_lab_pet_desc;

ANALYZE pet;
ANALYZE client;
ANALYZE audit_pet_accessorie;