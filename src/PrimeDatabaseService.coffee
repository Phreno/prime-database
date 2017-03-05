# --------------------
# Dépendances externes
# --------------------
VENDOR=
  sqlite:require('sqlite3').verbose()

CONFIGURATION=
  database: "#{__dirname}/../database/data/primeDB.db"
  mode:VENDOR.sqlite.OPEN_READONLY

QUERY=
  getNth:'SELECT rowid, value FROM prime WHERE rowid=?'

class PrimeDatabaseService
  constructor:(@configuration=CONFIGURATION)->

  getNth:(indice)->
    throw new ReferenceError "indice ne peut pas être null" if !indice?
    throw new TypeError "indice doit être un nombre" if typeof indice isnt "number"
    nth=null

    # Récupération du résultat
    onItemSelection=(err,row)->
      if err
        console.error 'ERR pendant la récupération des éléments',err
        throw err
      console.debug "DEBUG row: #{row}"
      nth=row

    # Fermeture de la connexion à la base de données
    onDatabaseConnectionClose=(err)->
      if err
        console.error 'ERR pendant la fermeture de la base de données', err
        throw err

    # Ouverture de la connexion à la base de données
    onDatabaseConnectionOpen=(err)->
      if err
        console.error 'ERR pendant l\'ouverture de la base de données', err
        throw err

    new VENDOR.sqlite.Database(
      CONFIGURATION.database,
      CONFIGURATION.mode,
      onDatabaseConnectionOpen).get(QUERY.getNth,onItemSelection)
    nth

module.exports=PrimeDatabaseService
