# --------------------
# Dépendances externes
# --------------------
VENDOR=
  winston:require 'winston'
  sqlite:require 'sqlite3'

# ------------------------
# Configuration du service
# ------------------------

# Les logs sont dans le dossier log
logFile=__filename.replace(/\w+\/service/, '/log')
# Les logs ont l'extension .log
logFile=logFile.replace(/\.\w+$/, '.log')

CONFIGURATION=
  database: __dirname.replace /\w+\/\w+$/, "database/data/primeDB.db"
  mode:VENDOR.sqlite.OPEN_READONLY
  logFile:
    filename: logFile

do configureWinston=->
  VENDOR.winston.add(VENDOR.winston.transports.File, CONFIGURATION.logFile)
  VENDOR.winston.remove(VENDOR.winston.transports.Console)
  VENDOR.winston.level='debug'

# --------------------
# Dépendances internes
# --------------------
LIB =
  query:require './query'
  errorManager:new (require './ErrorManager')()
  CallbackManager:require './CallbackManager'

# =======================================
# Service de requêtage de nombre premiers
# =======================================
class PrimeDatabaseService
  constructor:->
    VENDOR.winston.debug """
    PrimeDatabaseService()
    """
    @_callbackManager=undefined

  #
  # Récupère le nième nombre premier
  #
  nth:(indice, callback)->
    VENDOR.winston.debug "nth(#{indice})"

    LIB.errorManager.checkNonNull indice
    LIB.errorManager.checkNumber indice
    LIB.errorManager.checkNonNull callback
    LIB.errorManager.checkFunction callback

    @_callbackManager=new LIB.CallbackManager callback
    #TODO:Faire une database Factory
    new VENDOR.sqlite.Database(
      CONFIGURATION.database,
      CONFIGURATION.mode,
      @_callbackManager.onDatabaseConnectionOpen)
        .get(
          LIB.query.nth,
          indice,
          @_callbackManager.onItemSelection)
        .close @_callbackManager.onDatabaseConnectionClose

  #
  # Récupère la position d'un nombre premier
  #
  position:(value, callback)->
    VENDOR.winston.debug "position(#{value})"

    LIB.errorManager.checkNonNull value
    LIB.errorManager.checkNumber value
    LIB.errorManager.checkNonNull callback
    LIB.errorManager.checkFunction callback

    @_callbackManager=new LIB.CallbackManager callback

    new VENDOR.sqlite.Database(
      CONFIGURATION.database,
      CONFIGURATION.mode,
      @_callbackManager.onDatabaseConnectionOpen)
        .get(
          LIB.query.position,
          value,
          @_callbackManager.onItemSelection)
        .close @_callbackManager.onDatabaseConnectionClose

  #
  # Récupère les nombres premiers entre deux valeurs
  #
  allValuesIn:(min,max,callback)->
    VENDOR.winston.debug "allValuesIn(#{min},#{max})"

    LIB.errorManager.checkNonNull min
    LIB.errorManager.checkNonNull max
    LIB.errorManager.checkNonNull callback
    LIB.errorManager.checkNumber min
    LIB.errorManager.checkNumber max
    LIB.errorManager.checkFunction callback

    @_callbackManager=new LIB.CallbackManager callback

    new VENDOR.sqlite.Database(
      CONFIGURATION.database,
      CONFIGURATION.mode,
      @_callbackManager.onDatabaseConnectionOpen)
        .all(
          LIB.query.allValuesIn,
          min, max,
          @_callbackManager.onArraySelection)
        .close @_callbackManager.onDatabaseConnectionClose

module.exports=PrimeDatabaseService
