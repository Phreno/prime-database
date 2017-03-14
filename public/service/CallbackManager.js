var CallbackManager, LIB, VENDOR, doStuff;

VENDOR = {
  winston: require('winston')
};

LIB = {
  errorManager: new (require('./ErrorManager'))()
};

doStuff = void 0;

CallbackManager = (function() {
  function CallbackManager(callback) {
    doStuff = callback;
    VENDOR.winston.debug("CallbackManager");
  }

  CallbackManager.prototype.onItemSelection = function(err, row) {
    VENDOR.winston.debug("onItemSelection(\n" + (JSON.stringify(err, null, 2)) + ",\n" + (JSON.stringify(row, null, 2)) + ")");
    LIB.errorManager.checkError(err);
    if (row === null || row === void 0) {
      row = {
        rowid: null,
        value: null
      };
    }
    return doStuff(row);
  };

  CallbackManager.prototype.onDatabaseConnectionClose = function(err) {
    VENDOR.winston.debug("onDatabaseConnectionClose(" + (JSON.stringify(err, null, 2)) + ")");
    return LIB.errorManager.checkError(err);
  };

  CallbackManager.prototype.onDatabaseConnectionOpen = function(err) {
    VENDOR.winston.debug("onDatabaseConnectionOpen(" + (JSON.stringify(err, null, 2)) + ")");
    return LIB.errorManager.checkError(err);
  };

  return CallbackManager;

})();

module.exports = CallbackManager;
