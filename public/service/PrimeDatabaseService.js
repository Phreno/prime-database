var CONFIGURATION, PrimeDatabaseService, QUERY, VENDOR, configureWinston, logFile;

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

QUERY = {
  getNth: "SELECT rowid, value FROM prime WHERE rowid=?"
};

PrimeDatabaseService = (function() {
  function PrimeDatabaseService() {
    VENDOR.winston.debug("PrimeDatabaseService(" + (JSON.stringify(this.configuration, null, 2)) + ")");
  }

  PrimeDatabaseService.prototype.getNth = function(indice, callback) {
    var err, onDatabaseConnectionClose, onDatabaseConnectionOpen, onItemSelection;
    if (callback == null) {
      callback = console.log;
    }
    VENDOR.winston.debug("getNth(" + indice + ")");
    if (indice == null) {
      err = new ReferenceError("indice ne peut pas être null");
      VENDOR.winston.error(err);
      throw err;
      process.exit(1);
    }
    if (typeof indice !== "number") {
      err = new TypeError("indice doit être un nombre");
      VENDOR.winston.error(err);
      throw err;
      process.exit(1);
    }
    onItemSelection = function(err, row) {
      VENDOR.winston.debug("onItemSelection(\n" + (JSON.stringify(err, null, 2)) + ",\n" + (JSON.stringify(row, null, 2)) + ")");
      if (err) {
        VENDOR.winston.error(err);
        throw err;
        process.exit(1);
      }
      return callback(row);
    };
    onDatabaseConnectionClose = function(err) {
      VENDOR.winston.debug("onDatabaseConnectionClose(" + (JSON.stringify(err, null, 2)) + ")");
      if (err) {
        VENDOR.winston.error(err);
        throw err;
        return process.exit(1);
      }
    };
    onDatabaseConnectionOpen = function(err) {
      VENDOR.winston.debug("onDatabaseConnectionOpen(" + (JSON.stringify(err, null, 2)) + ")");
      if (err) {
        VENDOR.winston.error(err);
        throw err;
        return process.exit(1);
      }
    };
    return new VENDOR.sqlite.Database(CONFIGURATION.database, CONFIGURATION.mode, onDatabaseConnectionOpen).get(QUERY.getNth, indice, onItemSelection).close(onDatabaseConnectionClose);
  };

  return PrimeDatabaseService;

})();

module.exports = PrimeDatabaseService;
