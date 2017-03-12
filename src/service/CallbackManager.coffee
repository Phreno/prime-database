# Développeur ....: K3rn€l_P4n1K
LIB=
  errorManager:new (require './ErrorManager')()
# Description ....: CallbackManager - 1.0 - Sun Mar 12 11:45:08 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Gestion des callbacks durant le cycle de vie de
# ................. la requête sqlite3
# Intention ......: Alléger PrimeDatabaseService
# Remarque .......: En paramètre du constructeur le callback à jouer
# ................. à la récupération de la ligne.

# --------------------
# Dépendances externes
# --------------------
VENDOR=
  winston:require 'winston'

# --------------------
# Dépandances internes
# --------------------
LIB=
  errorManager:new (require './ErrorManager')()

class CallbackManager
  constructor:(@callback=console.log)->
    VENDOR.winston.debug """
    CallbackManager
    """

  # Récupération du résultat
  onItemSelection:(err,row)->
    VENDOR.winston.debug """
    onItemSelection(
    #{JSON.stringify err, null, 2},
    #{JSON.stringify row, null, 2})
    """
    LIB.errorManager.checkError err
    @callback row

  # Fermeture de la connexion à la base de données
  onDatabaseConnectionClose:(err)->
    VENDOR.winston.debug """
    onDatabaseConnectionClose(#{JSON.stringify err, null, 2})
    """
    LIB.errorManager.checkError err

  # Ouverture de la connexion à la base de données
  onDatabaseConnectionOpen:(err)->
    VENDOR.winston.debug """
    onDatabaseConnectionOpen(#{JSON.stringify err, null, 2})
    """
    LIB.errorManager.checkError err

module.exports=CallbackManager
