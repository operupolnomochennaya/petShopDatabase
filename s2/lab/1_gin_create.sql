DROP INDEX IF EXISTS gin_lab_pet_attr;
DROP INDEX IF EXISTS gin_lab_client_pref;
DROP INDEX IF EXISTS gin_lab_audit_diff;
DROP INDEX IF EXISTS gin_lab_pet_tags;
DROP INDEX IF EXISTS gin_lab_pet_desc;

CREATE INDEX gin_lab_pet_attr
ON pet USING GIN (attributes);

CREATE INDEX gin_lab_client_pref
ON client USING GIN (preferences);

CREATE INDEX gin_lab_audit_diff
ON audit_pet_accessorie USING GIN (diff);

CREATE INDEX gin_lab_pet_tags
ON pet USING GIN (tags);

CREATE INDEX gin_lab_pet_desc
ON pet USING GIN (description_tsv);

ANALYZE pet;
ANALYZE client;
ANALYZE audit_pet_accessorie;