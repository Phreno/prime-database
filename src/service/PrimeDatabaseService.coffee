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

VENDOR.winston.debug "Chargement du fichier #{__filename}"

# --------------------
# Dépenpances internes
# --------------------
#class CallbackManager
#  constructor:(@callback=console.log)->
#    VENDOR.winston.debug """
#    CallbackManager
#    """
#
#  # Récupération du résultat
#  onItemSelection:(err,row)->
#    VENDOR.winston.debug """
#    onItemSelection(
#    #{JSON.stringify err, null, 2},
#    #{JSON.stringify row, null, 2})
#    """
#    LIB.errorManager.checkError err
#    @callback row
#
#  # Fermeture de la connexion à la base de données
#  onDatabaseConnectionClose:(err)->
#    VENDOR.winston.debug """
#    onDatabaseConnectionClose(#{JSON.stringify err, null, 2})
#    """
#    LIB.errorManager.checkError err
#
#  # Ouverture de la connexion à la base de données
#  onDatabaseConnectionOpen:(err)->
#    VENDOR.winston.debug """
#    onDatabaseConnectionOpen(#{JSON.stringify err, null, 2})
#    """
#    LIB.errorManager.checkError err
#
LIB =
  query:require './query.coffee'
  errorManager:new (require './ErrorManager')()
  CallbackManager:require './CallbackManager'

class PrimeDatabaseService
  constructor:->
    VENDOR.winston.debug """
    PrimeDatabaseService()
    """
    @_callbackManager=undefined

  getNth:(indice, callback)->
    VENDOR.winston.debug "getNth(#{indice})"

    LIB.errorManager.checkNonNull indice
    LIB.errorManager.checkNumber indice

    @_callbackManager=new LIB.CallbackManager callback

    new VENDOR.sqlite.Database(
      CONFIGURATION.database,
      CONFIGURATION.mode,
      @_callbackManager.onDatabaseConnectionOpen)
        .get(
          LIB.query.getNth,
          indice,
          @_callbackManager.onItemSelection)
        .close @_callbackManager.onDatabaseConnectionClose

module.exports=PrimeDatabaseService
