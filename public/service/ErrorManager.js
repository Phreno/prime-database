var ErrorManager, VENDOR;

VENDOR = {
  winston: require('winston')
};

ErrorManager = (function() {
  function ErrorManager() {
    VENDOR.winston.debug("ErrorManager()");
  }

  ErrorManager.prototype.checkNonNull = function(variable, message) {
    var err;
    if (message == null) {
      message = 'ne peut pas etre null';
    }
    if (variable == null) {
      err = new ReferenceError(message);
      VENDOR.winston.error(err);
      throw err;
      return process.exit(1);
    }
  };

  ErrorManager.prototype.checkNumber = function(variable, message) {
    var err;
    if (message == null) {
      message = 'doit être un nombre';
    }
    if (typeof variable !== "number") {
      err = new TypeError(message);
      VENDOR.winston.error(err);
      throw err;
      return process.exit(1);
    }
  };

  ErrorManager.prototype.checkError = function(error) {
    if (error) {
      VENDOR.winston.error(error);
      throw error;
      return process.exit(1);
    }
  };

  return ErrorManager;

})();

module.exports = ErrorManager;
