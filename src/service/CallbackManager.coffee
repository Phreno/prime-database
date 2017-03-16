# Développeur ....: K3rn€l_P4n1K
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

# FIXME: Trouver comment faire passer le callback
# en propriété de la classe.

# Expose de façon affreuse le callback aux autres fonctions.
doStuff=undefined

class CallbackManager
  constructor:(callback)->
    doStuff=callback
    VENDOR.winston.debug """
    CallbackManager
    """

  # Récupération du résultat unique
  onItemSelection:(err,row)->
    VENDOR.winston.debug "onItemSelection()"
    LIB.errorManager.checkError err

    # Force la récupération d'un résultat
    if row is null or row is undefined
     row=
      rowid:null
      value:null

    doStuff row

  # Récupération du tableau de résultat
  onArraySelection:(err,arr)->
    VENDOR.winston.debug "onArraySelection"
    LIB.errorManager.checkError err

    # Force la récupération du résultat
    if arr is null or arr is undefined
      arr=[]

    doStuff arr

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
