# --------------------
# Dépendances externes
# --------------------
VENDOR=
  winston:require 'winston'
  q_sqlite:require 'q-sqlite3'

# ------------------------
# Configuration du service
# ------------------------

# Les logs sont dans le dossier log
logFile=__filename.replace(/\w+\/service/, '/log')
# Les logs ont l'extension .log
logFile=logFile.replace(/\.\w+$/, '.log')

CONTEXT=
  database:
    path:__dirname.replace /\w+\/\w+$/, "database/data/primeDB.db"
    instance:undefined
    maxValue:982451653
    maxId:50000000
  logFile:
    filename: logFile

do configureWinston=->
  VENDOR.winston.add(VENDOR.winston.transports.File, CONTEXT.logFile)
  VENDOR.winston.remove(VENDOR.winston.transports.Console)
  VENDOR.winston.level='debug'

# --------------------
# Dépendances internes
# --------------------
LIB =
  query:require './query'
  errorManager:new (require './ErrorManager')()
  #CallbackManager:require './CallbackManager'

# =======================================
# Service de requêtage de nombre premiers
# =======================================
class PrimeDatabaseService
  constructor:->
    VENDOR
      .winston
      .debug "PrimeDatabaseService()"

    VENDOR
      .q_sqlite
      .createDatabase CONTEXT.database.path
      .done((instance) -> CONTEXT.database.instance = instance)

  #
  # Récupère le context de la base de données
  #
  context:CONTEXT

  #
  # Récupère le nième nombre premier
  #
  nth:(indice, callback)->
    LIB.errorManager.checkNonNullNumber indice
    LIB.errorManager.checkNonNullFunction callback
    doStuff = (row)->
      row = { rowid:indice, value:null } if !row?
      row.value = undefined if row.rowid > CONTEXT.database.maxId
      callback row
    CONTEXT
      .database
      .instance
      .get LIB.query.nth, indice
      .then doStuff

module.exports=PrimeDatabaseService
