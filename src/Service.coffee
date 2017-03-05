#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: prime-database-service
# Date de création: samedi 4 mars 2017, 16:03:20 (UTC+0100)
# Plateformes ....: Ubuntu

# Fonctionnalité .: Librairie pour requêter la BDD de nombres premiers
# Intention ......: Fournir les autres applications en nombres premiers
# Remarque .......:

# ----------
# Constantes
# ----------
constant=
  # Version courante
  VERSION: require('./package.json').version
  # Fichier sqlite qui contient la base de données
  DATABASE_FILE:'./database/data/primeDB.db'

# --------------------
# Dépendances externes
# --------------------
vendor=
  sqlite:require('sqlite3').verbose()



class PrimeDatabaseService
  constructor:->
    # ------------------------
    # Configuration du service
    # ------------------------

    @configuration=
      databaseFile:constant.DATABASE_FILE
      query:null
      resultset:null

    # ------------------------
    # Traitement de la requête
    # ------------------------

    @callback=

      #
      # Traitement des résultats
      #
      onItemSelection:(err,row)->
        console.error(
          'ERR pendant la récupération des éléments',
          err) if err
        application.resultset.push row

      #
      # Fermeture de la connexion à la base de données
      #
      onDatabaseConnectionClose:(err)->
        console.error(
          'ERR pendant la fermeture de la base de données',
          err) if err

      #
      # Ouverture de la connexion à la base de données
      #
      onDatabaseConnectionOpen:(err)->
        console.error(
          'ERR pendant l\'ouverture de la base de données',
          err) if err
        database.each(@configuration.query, callback_onItemSelection)
        database.close callback_onDatabaseConnectionClose






# --------------
# Initialisation
# --------------

# Gestion des variables applicatives
application=
  # Instance de la base de données
  database:null
  # Résultat de la requête
  resultset:[]

# ---------
# Fonctions
# ---------

#
# Callbacks
#

# -----------------------
# Lancement de la routine
# -----------------------

database=new vendor.sqlite.Database(
  constant.DATABASE_FILE,
  vendor.sqlite.OPEN_READONLY,
  callback_onDatabaseConnectionOpen)
