var Printer;

Printer = (function() {
  function Printer() {}

  Printer.prototype.nth = function(row) {
    console.log(row.value);
    return process.exit(0);
  };

  Printer.prototype.isPrime = function(row) {
    if (row.rowid !== null) {
      console.log('true');
    } else {
      console.log('false');
    }
    return process.exit(0);
  };

  Printer.prototype.index = function(row) {
    if (row.rowid !== null) {
      console.log(row.rowid);
    } else {
      console.log('false');
    }
    return process.exit(0);
  };

  return Printer;

})();

module.exports = Printer;
