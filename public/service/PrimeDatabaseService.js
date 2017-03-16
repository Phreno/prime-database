var CONFIGURATION, LIB, PrimeDatabaseService, VENDOR, configureWinston, logFile;

VENDOR = {
  winston: require('winston'),
  sqlite: require('sqlite3')
};

logFile = __filename.replace(/\w+\/service/, '/log');

logFile = logFile.replace(/\.\w+$/, '.log');

CONFIGURATION = {
  database: __dirname.replace(/\w+\/\w+$/, "database/data/primeDB.db"),
  mode: VENDOR.sqlite.OPEN_READONLY,
  logFile: {
    filename: logFile
  }
};

(configureWinston = function() {
  VENDOR.winston.add(VENDOR.winston.transports.File, CONFIGURATION.logFile);
  VENDOR.winston.remove(VENDOR.winston.transports.Console);
  return VENDOR.winston.level = 'debug';
})();

LIB = {
  query: require('./query'),
  errorManager: new (require('./ErrorManager'))(),
  CallbackManager: require('./CallbackManager')
};

PrimeDatabaseService = (function() {
  function PrimeDatabaseService() {
    VENDOR.winston.debug("PrimeDatabaseService()");
    this._callbackManager = void 0;
  }

  PrimeDatabaseService.prototype.nth = function(indice, callback) {
    VENDOR.winston.debug("nth(" + indice + ")");
    LIB.errorManager.checkNonNull(indice);
    LIB.errorManager.checkNumber(indice);
    LIB.errorManager.checkNonNull(callback);
    LIB.errorManager.checkFunction(callback);
    this._callbackManager = new LIB.CallbackManager(callback);
    return new VENDOR.sqlite.Database(CONFIGURATION.database, CONFIGURATION.mode, this._callbackManager.onDatabaseConnectionOpen).get(LIB.query.nth, indice, this._callbackManager.onItemSelection).close(this._callbackManager.onDatabaseConnectionClose);
  };

  PrimeDatabaseService.prototype.position = function(value, callback) {
    VENDOR.winston.debug("position(" + value + ")");
    LIB.errorManager.checkNonNull(value);
    LIB.errorManager.checkNumber(value);
    LIB.errorManager.checkNonNull(callback);
    LIB.errorManager.checkFunction(callback);
    this._callbackManager = new LIB.CallbackManager(callback);
    return new VENDOR.sqlite.Database(CONFIGURATION.database, CONFIGURATION.mode, this._callbackManager.onDatabaseConnectionOpen).get(LIB.query.position, value, this._callbackManager.onItemSelection).close(this._callbackManager.onDatabaseConnectionClose);
  };

  PrimeDatabaseService.prototype.allValuesIn = function(min, max, callback) {
    VENDOR.winston.debug("allValuesIn(" + min + "," + max + ")");
    LIB.errorManager.checkNonNull(min);
    LIB.errorManager.checkNonNull(max);
    LIB.errorManager.checkNonNull(callback);
    LIB.errorManager.checkNumber(min);
    LIB.errorManager.checkNumber(max);
    return LIB.errorManager.checkFunction(callback);
  };

  return PrimeDatabaseService;

})();

module.exports = PrimeDatabaseService;
