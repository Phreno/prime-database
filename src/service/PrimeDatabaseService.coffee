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

# ---------------------------
# Liste des requêtes exposées
# ---------------------------

QUERY=

  getNth:"""
  SELECT  rowid, value
  FROM    prime
  WHERE   rowid=?;
  """

  isPrime:"""
  SELECT  rowid, value
  FROM    prime
  WHERE   value=?
  """

# -------------------
# Gestion des Erreurs
# -------------------

class ErrorManager
  constructor:->
    VENDOR.winston.debug """
    ErrorManager()
    """

  checkNonNull:(variable, message='ne peut pas etre null')->
    if !variable?
      err=new ReferenceError message
      VENDOR.winston.error err
      throw err
      process.exit 1

  checkNumber:(variable, message='doit être un nombre')->
    if typeof variable isnt "number"
      err=new TypeError message
      VENDOR.winston.error err
      throw err
      process.exit 1

  checkError:(error)->
    if error
      VENDOR.winston.error error
      throw error
      process.exit 1

# --------------------
# Dépenpances internes
# --------------------
LIB =
  query:QUERY
  errorManager:new ErrorManager()

class PrimeDatabaseService
  constructor:->
    VENDOR.winston.debug """
    PrimeDatabaseService()
    """

  getNth:(indice, callback=console.log)->
    VENDOR.winston.debug "getNth(#{indice})"
    LIB.errorManager.checkNonNull indice
    LIB.errorManager.checkNumber indice

    # Récupération du résultat
    onItemSelection=(err,row)->
      VENDOR.winston.debug """
      onItemSelection(
      #{JSON.stringify err, null, 2},
      #{JSON.stringify row, null, 2})
      """
      LIB.errorManager.checkError err
      callback row

    # Fermeture de la connexion à la base de données
    onDatabaseConnectionClose=(err)->
      VENDOR.winston.debug """
      onDatabaseConnectionClose(#{JSON.stringify err, null, 2})
      """
      LIB.errorManager.checkError err

    # Ouverture de la connexion à la base de données
    onDatabaseConnectionOpen=(err)->
      VENDOR.winston.debug """
      onDatabaseConnectionOpen(#{JSON.stringify err, null, 2})
      """
      LIB.errorManager.checkError err

    new VENDOR.sqlite.Database(
      CONFIGURATION.database,
      CONFIGURATION.mode,
      onDatabaseConnectionOpen
    ).get(
      LIB.query.getNth
      ,indice
      ,onItemSelection).close onDatabaseConnectionClose

module.exports=PrimeDatabaseService
