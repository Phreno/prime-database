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
  errorManager:new (require './ErrorManager')(CONTEXT)

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
  # Travail avec le nième nombre premier
  #
  nth:(indice, callback)->
    LIB.errorManager.checkMaxIndex indice
    LIB.errorManager.checkNonNullFunction callback
    doStuff=(row)->
      row = {rowid:indice, value:null} if !row?
      callback row
    CONTEXT.database.instance.get LIB.query.nth, indice
      .then doStuff

  #
  # Travail avec la position du nombre premier passé en paramètre
  #
  position:(value, callback)->
    LIB.errorManager.checkMaxValue value
    LIB.errorManager.checkNonNullFunction callback
    doStuff=(row)->
      row = {rowid:null, value:value} if !row?
      callback row
    CONTEXT.database.instance.get LIB.query.position, value
      .then doStuff

  #
  # Travail avec les nombres premiers compris entre min & max
  #
  allValuesIn:(min, max, callback)->
    LIB.errorManager.checkNonNullNumber min
    LIB.errorManager.checkNonNullNumber max
    LIB.errorManager.checkNonNullFunction callback
    [min,max]=[max,min] if min>max
    LIB.errorManager.checkMaxValue max
    doStuff=(arr)->
      arr=[] if !arr?
      callback arr
    CONTEXT.database.instance.all LIB.query.allValuesIn, {$min:min, $max:max}
      .then doStuff

module.exports=PrimeDatabaseService
