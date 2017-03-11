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

CONSTANT=
  # Version courante
  version: require('./package.json').version

# --------------------
# Dépendances externes
# --------------------

VENDOR=
  program:require 'commander'

LIB=
  primeDB:require './src/PrimeDatabaseService.js'
# --------------
# Initialisation
# --------------

# Gestion des arguments console
VENDOR.program
  .version(CONSTANT.version)
  .option('-n, --nth [indice]', 'Donne la valeur du nombre premier à l\'indice n', 1)
  .parse process.argv

if VENDOR.program.nth
  LIB.primeDB.getNth VENDOR.program.nth

