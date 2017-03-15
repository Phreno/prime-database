# Développeur ....: K3rn€l_P4n1K
# Description ....: query - 1.0 - Sun Mar 12 10:01:37 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Liste des requêtes jouées par le service
# Intention ......: Alléger le fichier PrimeDatabaseService.coffee
# Remarque .......:

module.exports=
  getNth:"""
  SELECT  rowid, value
  FROM    prime
  WHERE   rowid=?;
  """

  getPosition:"""
  SELECT  rowid, value
  FROM    prime
  WHERE   value=?;
  """

  getPrimesBetweenValues:"""
  SELECT  rowid, value
  FROM    prime
  WHERE   value >= ? AND value <= ?;
  """
