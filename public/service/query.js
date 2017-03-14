module.exports = {
  getNth: "SELECT  rowid, value\nFROM    prime\nWHERE   rowid=?;",
  isPrime: "SELECT  rowid, value\nFROM    prime\nWHERE   value=?;"
};
