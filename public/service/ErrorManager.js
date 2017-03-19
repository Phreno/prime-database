var ErrorManager, VENDOR, checkError, checkFunction, checkMaxIndex, checkMaxValue, checkNonNull, checkNonNullFunction, checkNonNullNumber, checkNumber;

VENDOR = {
  winston: require('winston')
};

checkNonNull = function(variable, message) {
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

checkNumber = function(variable, message) {
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

checkFunction = function(variable, message) {
  var err;
  if (message == null) {
    message = 'doit être une fonction';
  }
  if (typeof variable !== "function") {
    err = new TypeError(message);
    VENDOR.winston.error(err);
    throw err;
    return process.exit(1);
  }
};

checkError = function(error) {
  if (error) {
    VENDOR.winston.error(error);
    throw error;
    return process.exit(1);
  }
};

checkNonNullNumber = function(variable, message) {
  if (message == null) {
    message = 'doit être un nombre non null';
  }
  checkNonNull(variable);
  return checkNumber(variable);
};

checkNonNullFunction = function(variable, message) {
  if (message == null) {
    message = 'doit être une fonction non nulle';
  }
  checkNonNull(variable);
  return checkFunction(variable);
};

checkMaxValue = function(variable, message) {
  var err;
  if (message == null) {
    message = 'en dehors des données disponnibles';
  }
  checkNonNullNumber(variable);
  if (variable > this.context.database.maxValue) {
    err = new ReferenceError(message);
    VENDOR.winston.error(err);
    throw err;
    return process.exit(1);
  }
};

checkMaxIndex = function(variable, message) {
  var err;
  if (message == null) {
    message = 'en dehors des données disponnibles';
  }
  checkNonNullNumber(variable);
  if (variable > this.context.database.maxId) {
    err = new ReferenceError(message);
    VENDOR.winston.error(err);
    throw err;
    return process.exit(1);
  }
};

ErrorManager = (function() {
  function ErrorManager(context) {
    this.context = context;
    VENDOR.winston.debug('ErrorManager()');
  }

  ErrorManager.prototype.checkNonNull = checkNonNull;

  ErrorManager.prototype.checkNumber = checkNumber;

  ErrorManager.prototype.checkFunction = checkFunction;

  ErrorManager.prototype.checkError = checkError;

  ErrorManager.prototype.checkMaxValue = checkMaxValue;

  ErrorManager.prototype.checkMaxIndex = checkMaxIndex;

  ErrorManager.prototype.checkNonNullNumber = checkNonNullNumber;

  ErrorManager.prototype.checkNonNullFunction = checkNonNullFunction;

  return ErrorManager;

})();

module.exports = ErrorManager;
