# Développeur ....: K3rn€l_P4n1K
# Description ....: ErrorManager - 1.0 - Sun Mar 12 10:05:04 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Gestionnaire des erreurs
# Intention ......: Simplifier PrimeDatabaseService.coffee
# Remarque .......:

# --------------------
# Dépendances externes
# --------------------
VENDOR=
  winston:require 'winston'

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

module.exports=ErrorManager
