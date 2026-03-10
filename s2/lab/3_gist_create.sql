DROP INDEX IF EXISTS gist_lab_pet_stay;
DROP INDEX IF EXISTS gist_lab_emp_years;
DROP INDEX IF EXISTS gist_lab_petshop_loc;

CREATE INDEX gist_lab_pet_stay
ON pet USING GIST (stay);

CREATE INDEX gist_lab_emp_years
ON employee USING GIST (work_years);

CREATE INDEX gist_lab_petshop_loc
ON petshop USING GIST (location);

ANALYZE pet;
ANALYZE employee;
ANALYZE petshop;