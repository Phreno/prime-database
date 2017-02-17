#!/bin/sh
# ..............
# [K3rn€l_P4n1k]
# ..............

# TODO
# ensure args 
# catch error

# =====
# SETUP
# =====

#
# Installe la base de données des nombres premiers
#
primeDB_setup(){
  echo ".. INFO setup primeDB"
  primeDB_removeData
  primeDB_downloadPrimes
  primeDB_cleanFolder
  primeDB_normalizeDatafileName
  primeDB_backupData
  echo ".. INFO setup done"
}

#
# Télécharge tous les fichier zip disponibles à l'URL
# indiquée dans le dossier passé en paramètre
#
primeDB_downloadPrimes(){
  folder=${1:-${primeDB_DATA_FOLDER}}
  url="http://primes.utm.edu/lists/small/millions"
  format="zip"
  echo ".. INFO download primes archive from ${url} into ${folder}"
  wget -P ${folder} -r -np -nd -l 1 -A ${format} ${url}
  echo ".. INFO download done"
}

#
# Supprime les fichiers inutiles
#
primeDB_cleanFolder(){
  folder=${1:-${primeDB_DATA_FOLDER}}
  useless="robots.txt"
  echo ".. INFO clean prime data folder from useless files"
  rm ${folder}/${useless}
  echo ".. INFO clean done"
}

#
# Désinstalle la banque de données
#
primeDB_removeData(){
  folder=${1:-${primeDB_DATA_FOLDER}}
  echo ".. INFO delete primes data"
  rm -rf ${folder}
  echo ".. INFO delete done"
}

#
# Sauvegarde les données
#
primeDB_backupData(){
  folder=$( basename ${1:-${primeDB_DATA_FOLDER}} )
  archive=${2:-${primeDB_ARCHIVE}}
  echo ".. INFO backup data into ${archive}"
  tar cvf ${archive} ${folder}
  echo ".. INFO backup done"
}

#
# Restaure les données
#
primeDB_restoreData(){
  primeDB_removeData
  archive=${2:-${primeDB_ARCHIVE}}
  echo ".. INFO restore backup from ${archive}"
  tar xvf ${archive}
  echo ".. INFO restore done"
}

#
# Normalise les indices suffixées sur les noms de fichier
#
primeDB_normalizeDatafileName(){
  folder=${1:-${primeDB_DATA_FOLDER}}
  currentFolder=$(pwd)
  cd ${folder}
  for f in primes[0-9]*;
  do
    indice=$( printf ${primeDB_PADDING} ${${f#primes}%.zip} )
    new="${indice}.zip"
    echo "moving $f to $new"
    mv $f $new;
  done
  cd ${currentFolder}
}
