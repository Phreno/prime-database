module.exports = {
  nth: "SELECT  rowid, value\nFROM    prime\nWHERE   rowid=?;",
  position: "SELECT  rowid, value\nFROM    prime\nWHERE   value=?;",
  allValuesIn: "SELECT  rowid, value\nFROM    prime\nWHERE   value >= $min AND value <= $max;"
};
