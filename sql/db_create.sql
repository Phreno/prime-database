CREATE
TABLE prime (
  indice INTEGER PRIMARY KEY
  , value INTEGER
  , source VARCHAR(50)
);

-- ALTER
-- TABLE prime
-- ADD COLUMN date_creation DATE
-- DEFAULT DATE (
--   STRFTIME(
--     "%Y-%m-%d %H:%M:%S"
--     ,'now'
--     ,'localtime'
-- ));
