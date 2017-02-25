#!/bin/bash
# ..............
# [K3rn€l_P4n1k]
# ..............

# =============
# SETUP_PROFILE
# =============
#
# Fonctions utilitaires pour l'installation de la base de données

primeDB_SETUP_PROFILE="${BASH_SOURCE[0]:-$(realpath ${0})}"
primeDB_SETUP_PROFILE_DIR="$( dirname ${primeDB_SETUP_PROFILE} )"

#
# Télécharge tous les fichier zip disponibles à l'URL
# indiquée dans le dossier passé en paramètre
#
primeDB_setup_downloadPrimes(){
  folder="${1:-${primeDB_DATA_DIR?}}"
  url="${2:-${primeDB_ZIP_URL?}}"
  format="${3:-${primeDB_DATA_COMPRESSION?}}"

  echo ".. INFO download primes archive from ${url} into ${folder}"
  wget -P ${folder} -r -np -nd -l 1 -A ${format} ${url}
  echo ".. INFO download done"
}

#
# Supprime les fichiers inutiles
#
primeDB_setup_cleanFolder(){
  folder="${1:-${primeDB_DATA_DIR?}}"
  useless="robots.txt"
  echo ".. INFO clean prime data folder from useless files"
  rm ${folder}/${useless}
  echo ".. INFO clean done"
}

#
# Désinstalle la banque de données
#
primeDB_setup_removeData(){
  folder="${1:-${primeDB_DATA_DIR?}}"
  echo ".. INFO delete possible previous install"
  rm -rf ${folder}
  echo ".. INFO delete done"
}

#
# Sauvegarde les données
#
primeDB_setup_backupData(){
  folder="${1:-${primeDB_DATA_DIR?}}"
  archive="${2:-${primeDB_ARCHIVE?}}"
  echo ".. INFO backup data into ${archive}"
  tar cvf ${archive} ${folder}
  echo ".. INFO backup done"
}

#
# Décompresse les fichiers
#
primeDB_setup_unzipPrimes(){
  primesLocation="${1:-${primeDB_DATA_DIR?}}"
  echo ".. INFO extracting primes"
  for file in $( find "${primesLocation}" -name "*.zip" ); do
    unzip "${file}" -d "${primesLocation}";
  done
  echo ".. INFO extraction done"
}


#
# Restaure les données
#
primeDB_setup_restoreData(){
  primeDB_removeData # Ensure no extra files in destination folder
  archive="${2:-${primeDB_ARCHIVE?}}"
  echo ".. INFO restore backup from ${archive}"
  tar xvf ${archive}
  echo ".. INFO restore done"
}

#
# Normalise les indices suffixées sur les noms de fichier.
# Permet le tri par ordre croissant (on veut éviter un tri sur plusieurs millions de lignes)
#
primeDB_setup_normalizeDatafileName(){
  folder="${1:-${primeDB_DATA_DIR?}}"
  padding="${2:-${primeDB_DATA_PADDING?}}"
  format="${3:-${primeDB_DATA_EXT?}}"
  prefix="primes"
  allChunks="${folder}/${prefix}*.${format}"

  for chunk in $allChunks;
  do
    indice=$( basename $chunk )
    indice=${indice#${prefix}}
    indice=${indice%.${format}}
    indice=$( printf ${padding} ${indice} )
    new="$( dirname $chunk )/${indice}"
    echo "moving ${chunk} to ${new}"
    mv ${chunk} ${new}
  done
}

#
# Supprime les fichiers zip
#
primeDB_setup_removeZipFiles(){
  folder="${1:-${primeDB_DATA_DIR?}}"
  format="${2:-${primeDB_DATA_COMPRESSION?}}"
  echo "..INFO removing zip files"
  rm ${folder}/*.${format} -v
  echo "..INFO removing done"
}

#
# Crée la base de données
#
primeDB_setup_createDB(){
  database="${1:-${primeDB_DATABASE?}}"
  script="${2:-${primeDB_SQL_CREATE?}}"
  cat "${script}" | sqlite3 "${database}"
}

