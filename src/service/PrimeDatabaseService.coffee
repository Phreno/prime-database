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
  getNth:"SELECT rowid, value FROM prime WHERE rowid=?"

class PrimeDatabaseService
  constructor:->
    VENDOR.winston.debug """
    PrimeDatabaseService(#{JSON.stringify @configuration, null, 2})
    """

  getNth:(indice, callback=console.log)->
    VENDOR.winston.debug "getNth(#{indice})"

    if !indice?
      err=new ReferenceError "indice ne peut pas être null"
      VENDOR.winston.error err
      throw err
      process.exit 1

    if typeof indice isnt "number"
      err=new TypeError "indice doit être un nombre"
      VENDOR.winston.error err
      throw err
      process.exit 1

    # Récupération du résultat
    onItemSelection=(err,row)->
      VENDOR.winston.debug """
      onItemSelection(
      #{JSON.stringify err, null, 2},
      #{JSON.stringify row, null, 2})
      """

      if err
        VENDOR.winston.error err
        throw err
        process.exit 1

      callback row

    # Fermeture de la connexion à la base de données
    onDatabaseConnectionClose=(err)->
      VENDOR.winston.debug """
      onDatabaseConnectionClose(#{JSON.stringify err, null, 2})
      """

      if err
        VENDOR.winston.error err
        throw err
        process.exit 1

    # Ouverture de la connexion à la base de données
    onDatabaseConnectionOpen=(err)->
      VENDOR.winston.debug """
      onDatabaseConnectionOpen(#{JSON.stringify err, null, 2})
      """

      if err
        VENDOR.winston.error err
        throw err
        process.exit 1

    new VENDOR.sqlite.Database(
      CONFIGURATION.database,
      CONFIGURATION.mode,
      onDatabaseConnectionOpen
    ).get(
      QUERY.getNth
      ,indice
      ,onItemSelection).close onDatabaseConnectionClose

module.exports=PrimeDatabaseService
