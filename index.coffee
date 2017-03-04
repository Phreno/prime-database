#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: prime-database-client
# Date de création: samedi 4 mars 2017, 16:03:20 (UTC+0100)
# Plateformes ....: Ubuntu

# Fonctionnalité .: Client pour requêter la BDD de nombres premiers
# Intention ......: Fournir les autres applications en nombres premiers
# Remarque .......:

# ----------
# Constantes
# ----------

constant=
  # Version courante
  VERSION: require('./package.json').version
  # Fichier sqlite qui contient la base de données
  DATABASE_FILE:'./data/primeDB.db'

# --------------------
# Dépendances externes
# --------------------

vendor=
  sqlite:require('sqlite3').verbose()
  program:require 'commander'

# --------------
# Initialisation
# --------------

# Gestion des arguments console
vendor.program
  .version(constant.VERSION)
  .option('-q, --query [string]', 'Requête SQLite de sélection')
  .parse process.argv

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

# Traitement des résultat
callback_onItemSelection=(err,row)->
  console.error(
    'ERR pendant la récupération des éléments',
    err) if err
  application.resultset.push row

# Fermeture de la connexion à la base de données
callback_onDatabaseConnectionClose=(err)->
  console.error(
    'ERR pendant la fermeture de la base de données',
    err) if err
  console.log application.resultset

# Ouverture de la connexion à la base de données
callback_onDatabaseConnectionOpen=(err)->
  console.error(
    'ERR pendant l\'ouverture de la base de données',
    err) if err
  #database.each(application.query, callback_onItemSelection)
  database.each(vendor.program.query, callback_onItemSelection)
  database.close callback_onDatabaseConnectionClose

# -----------------------
# Lancement de la routine
# -----------------------

database=new vendor.sqlite.Database(
  constant.DATABASE_FILE,
  vendor.sqlite.OPEN_READONLY,
  callback_onDatabaseConnectionOpen)
