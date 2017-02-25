CREATE TABLE prime (id integer primary key, value integer, source VARCHAR(50));
ALTER TABLE prime ADD COLUMN date_creation date DEFAULT date(strftime("%Y-%m-%d %H:%M:%S",'now','localtime'));
