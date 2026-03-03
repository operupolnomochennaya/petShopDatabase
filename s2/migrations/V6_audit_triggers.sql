BEGIN;

CREATE OR REPLACE FUNCTION fn_audit_pet_accessorie()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_action text;
  v_old_amount int;
  v_new_amount int;
BEGIN
  IF TG_OP = 'INSERT' THEN
    v_action := 'insert';
    v_old_amount := NULL;
    v_new_amount := NEW.amount;

    INSERT INTO audit_pet_accessorie(
      changed_at, action, username, pet_id, accessorie_id,
      old_amount, new_amount, diff, flags
    )
    VALUES (
      now(), v_action, current_user, NEW.pet_id, NEW.accessorie_id,
      v_old_amount, v_new_amount,
      jsonb_build_object(
        'op', TG_OP,
        'new', jsonb_build_object('amount', NEW.amount)
      ),
      ARRAY['trigger','auto']
    );

    RETURN NEW;

  ELSIF TG_OP = 'UPDATE' THEN
    v_action := 'update';
    v_old_amount := OLD.amount;
    v_new_amount := NEW.amount;

    INSERT INTO audit_pet_accessorie(
      changed_at, action, username, pet_id, accessorie_id,
      old_amount, new_amount, diff, flags
    )
    VALUES (
      now(), v_action, current_user, NEW.pet_id, NEW.accessorie_id,
      v_old_amount, v_new_amount,
      jsonb_build_object(
        'op', TG_OP,
        'old', jsonb_build_object('amount', OLD.amount),
        'new', jsonb_build_object('amount', NEW.amount)
      ),
      ARRAY['trigger','auto']
    );

    RETURN NEW;

  ELSIF TG_OP = 'DELETE' THEN
    v_action := 'delete';
    v_old_amount := OLD.amount;
    v_new_amount := NULL;

    INSERT INTO audit_pet_accessorie(
      changed_at, action, username, pet_id, accessorie_id,
      old_amount, new_amount, diff, flags
    )
    VALUES (
      now(), v_action, current_user, OLD.pet_id, OLD.accessorie_id,
      v_old_amount, v_new_amount,
      jsonb_build_object(
        'op', TG_OP,
        'old', jsonb_build_object('amount', OLD.amount)
      ),
      ARRAY['trigger','auto']
    );

    RETURN OLD;
  END IF;

  RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_pet_accessorie ON pet_accessorie;

CREATE TRIGGER trg_audit_pet_accessorie
AFTER INSERT OR UPDATE OR DELETE
ON pet_accessorie
FOR EACH ROW
EXECUTE FUNCTION fn_audit_pet_accessorie();

COMMIT;