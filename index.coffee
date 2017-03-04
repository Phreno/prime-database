#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: prime-database-client 1.0
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
  VERSION: '1.0'
  # Fichier sqlite qui contient la base de données
  DATABASE_FILE:'./data/primeDB.db'
  # Requête initiale
  SELECT_QUERY:'SELECT rowid, value FROM prime '

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
  .option('-f, --filter [string]', 'Ajoute une clause where sur la requête initiale (ex: rowid=100 or rowid=200)')
  .parse process.argv

# Gestion des variables applicatives
application=
  # Instance de la base de données
  database:null
  # Résultat de la requête
  resultset:[]
  # Requête de sélection
  query:constant.SELECT_QUERY

application.query+="WHERE #{vendor.program.filter}" if (vendor.program.filter)

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
    err)
  console.log application.resultset

# Ouverture de la connexion à la base de données
callback_onDatabaseConnectionOpen=(err)->
  console.error(
    'ERR pendant l\'ouverture de la base de données',
    err) if err
  database.each(application.query, callback_onItemSelection)
  database.close

# -----------------------
# Lancement de la routine
# -----------------------

database=new vendor.sqlite.Database(
  #constant.DATABASE_FILE,
  '/home/etienne/workspace/primeWorkspace/prime-database/data/primeDB.db',
  vendor.sqlite.OPEN_READONLY,
  callback_onDatabaseConnectionOpen)
