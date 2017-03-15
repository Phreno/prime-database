module.exports = {
  getNth: "SELECT  rowid, value\nFROM    prime\nWHERE   rowid=?;",
  getPosition: "SELECT  rowid, value\nFROM    prime\nWHERE   value=?;",
  getPrimesBetweenValues: "SELECT  rowid, value\nFROM    prime\nWHERE   value >= ? AND value <= ?;"
};
