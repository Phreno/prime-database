var CONTEXT, LIB, PrimeDatabaseService, VENDOR, configureWinston, logFile;

VENDOR = {
  winston: require('winston'),
  q_sqlite: require('q-sqlite3')
};

logFile = __filename.replace(/\w+\/service/, '/log');

logFile = logFile.replace(/\.\w+$/, '.log');

CONTEXT = {
  database: {
    path: __dirname.replace(/\w+\/service$/, "database/data/primeDB.db"),
    instance: void 0,
    maxValue: 982451653,
    maxId: 50000000
  },
  logFile: {
    filename: logFile
  }
};

(configureWinston = function() {
  VENDOR.winston.add(VENDOR.winston.transports.File, CONTEXT.logFile);
  VENDOR.winston.remove(VENDOR.winston.transports.Console);
  return VENDOR.winston.level = 'debug';
})();

LIB = {
  query: require('./query'),
  errorManager: new (require('./ErrorManager'))(CONTEXT)
};

PrimeDatabaseService = (function() {
  function PrimeDatabaseService() {
    VENDOR.winston.debug("PrimeDatabaseService()");
    VENDOR.q_sqlite.createDatabase(CONTEXT.database.path).done(function(instance) {
      return CONTEXT.database.instance = instance;
    });
  }

  PrimeDatabaseService.prototype.context = CONTEXT;

  PrimeDatabaseService.prototype.nth = function(indice, callback) {
    var doStuff;
    LIB.errorManager.checkMaxIndex(indice);
    LIB.errorManager.checkNonNullFunction(callback);
    doStuff = function(row) {
      if (row == null) {
        row = {
          rowid: indice,
          value: null
        };
      }
      return callback(row);
    };
    return CONTEXT.database.instance.get(LIB.query.nth, indice).then(doStuff);
  };

  PrimeDatabaseService.prototype.position = function(value, callback) {
    var doStuff;
    LIB.errorManager.checkMaxValue(value);
    LIB.errorManager.checkNonNullFunction(callback);
    doStuff = function(row) {
      if (row == null) {
        row = {
          rowid: null,
          value: value
        };
      }
      return callback(row);
    };
    return CONTEXT.database.instance.get(LIB.query.position, value).then(doStuff);
  };

  PrimeDatabaseService.prototype.allValuesIn = function(min, max, callback) {
    var doStuff, ref;
    LIB.errorManager.checkNonNullNumber(min);
    LIB.errorManager.checkNonNullNumber(max);
    LIB.errorManager.checkNonNullFunction(callback);
    if (min > max) {
      ref = [max, min], min = ref[0], max = ref[1];
    }
    LIB.errorManager.checkMaxValue(max);
    doStuff = function(arr) {
      if (arr == null) {
        arr = [];
      }
      return callback(arr);
    };
    return CONTEXT.database.instance.all(LIB.query.allValuesIn, {
      $min: min,
      $max: max
    }).then(doStuff);
  };

  return PrimeDatabaseService;

})();

module.exports = PrimeDatabaseService;
