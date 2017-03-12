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

VENDOR.winston.debug("Chargement du fichier " + __filename);

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

  PrimeDatabaseService.prototype.getNth = function(indice, callback) {
    VENDOR.winston.debug("getNth(" + indice + ")");
    LIB.errorManager.checkNonNull(indice);
    LIB.errorManager.checkNumber(indice);
    this._callbackManager = new LIB.CallbackManager(callback);
    return new VENDOR.sqlite.Database(CONFIGURATION.database, CONFIGURATION.mode, this._callbackManager.onDatabaseConnectionOpen).get(LIB.query.getNth, indice, this._callbackManager.onItemSelection).close(this._callbackManager.onDatabaseConnectionClose);
  };

  return PrimeDatabaseService;

})();

module.exports = PrimeDatabaseService;
