/* Setup todo table. */

CREATE TABLE todo(
  id         SERIAL,
  todo_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
  version    INTEGER NOT NULL DEFAULT 1,
  content    TEXT,
  point      INTEGER
);

CREATE OR REPLACE FUNCTION version_update() RETURNS TRIGGER AS
$$
BEGIN

  NEW.updated_at = NOW();
  NEW.version = NEW.version + 1;
  RETURN NEW;

END;
$$ language 'plpgsql'
SECURITY DEFINER
COST 10;

CREATE TRIGGER todo_update_trigger
BEFORE UPDATE
    ON todo
   FOR EACH ROW
       EXECUTE PROCEDURE version_update();
