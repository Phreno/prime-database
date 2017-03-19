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

checkNonNull=(variable, message='ne peut pas etre null')->
  if !variable?
    err=new ReferenceError message
    VENDOR.winston.error err
    throw err
    process.exit 1

checkNumber=(variable, message='doit être un nombre')->
  if typeof variable isnt "number"
    err=new TypeError message
    VENDOR.winston.error err
    throw err
    process.exit 1

checkFunction=(variable, message='doit être une fonction')->
  if typeof variable isnt "function"
    err=new TypeError message
    VENDOR.winston.error err
    throw err
    process.exit 1

checkError=(error)->
  if error
    VENDOR.winston.error error
    throw error
    process.exit 1

checkNonNullNumber=(variable, message='doit être un nombre non null')->
  checkNonNull variable
  checkNumber variable

checkNonNullFunction=(variable, message='doit être une fonction non nulle')->
  checkNonNull variable
  checkFunction variable

checkMaxValue=(variable, message='en dehors des données disponnibles')->
  checkNonNullNumber variable
  if variable > @context.database.maxValue
    err=new ReferenceError message
    VENDOR.winston.error err
    throw err
    process.exit 1

checkMaxIndex=(variable,message='en dehors des données disponnibles')->
  checkNonNullNumber variable
  if variable > @context.database.maxId
    err=new ReferenceError message
    VENDOR.winston.error err
    throw err
    process.exit 1
# -------------------
# Gestion des Erreurs
# -------------------

class ErrorManager
  constructor:(@context)->
    VENDOR.winston.debug 'ErrorManager()'

  checkNonNull:checkNonNull
  checkNumber:checkNumber
  checkFunction:checkFunction
  checkError:checkError
  checkMaxValue:checkMaxValue
  checkMaxIndex:checkMaxIndex
  checkNonNullNumber:checkNonNullNumber
  checkNonNullFunction:checkNonNullFunction
module.exports=ErrorManager
