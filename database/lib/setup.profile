#!/bin/bash
#!/bin/bash

# ...............................................................
# [K3rn€l_P4n1k] - primeDB_setup/setup.profile - 1.0 - 2017.02.26
# ...............................................................

# Description
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
  wget -P "${folder}" -r -np -nd -l 1 -A "${format}" "${url}"
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

  rm "${database}" -f
  cat "${script}" | sqlite3 "${database}"
}

#
# Insère la ligne d'un chunk en base de données
#
primeDB_setup_chunk_loadLine(){
  chunk="${1:-1}"
  lineIndex="${2:-1}"
  sqlTemplate="${3:-${primeDB_SQL_INSERT}}"

  sqlTemplate="$( cat "${sqlTemplate}" )"
  line="$( primeDB_CORE_chunk_getLine "${chunk}" "${lineIndex}" )"

  i=1
  pattern=''
  for prime in $( echo "${line}"); do
    if (( ${i} < 9 )); then
      anchor="@${i}"
      pattern="s/${anchor}/${prime}/g ; ${pattern}"
    fi
    i=$(( i + 1 ))
  done
  sqlTemplate="$( echo "${sqlTemplate}" | sed "${pattern}")"
  echo ${sqlTemplate} | sqlite3 "${primeDB_DATABASE}"
}

# UGLY PERF
# Insère un chunk en base de données
#
primeDB_setup_loadChunk_lineByLine(){
  chunk="${1:-1}"
  for ln in $( seq 1 1 "${primeDB_CHUNK_LINES}" ); do
    primeDB_setup_chunk_loadLine "${chunk}" "${ln}"
    if !(( ln % 10 )); then
      echo "$..INFO ${ln} lignes inserees a partir du chunk ${chunk}"
    fi
  done
}

#
# Transforme un chunk vers un csv
#
primeDB_setup_chunk_toCsv(){
  chunk="${1:-1}"
  merge="${primeDB_IMPORT}"

  chunk="$( primeDB_CORE_chunk_getPath "${chunk}" )"
  oneColumn='s/[[:space:]]\+/\n/g'
  digitFilter='[[:digit:]]'
  crumb=','
  csv="$(cat "${chunk}" | sed "${oneColumn}" | grep "${digitFilter}" | grep -v "${crumb}")"
  echo ".. INFO merge chunk ${chunk} into import file"
  echo "${csv}" >> "${primeDB_IMPORT}"
  rm -f "${chunk}"
}

#
# Import les nombres premiers dans la base de données
#
primeDB_setup_importCsv(){
  csv="${1:-${primeDB_IMPORT?}}"
  database="${2:-${primeDB_DATABASE?}}"
  scriptImport="${3:-${primeDB_SQL_IMPORT?}}"

  csv="$( echo "${csv}" | sed 's/\//\\\//g' )"
  scriptImport="$( cat "${scriptImport}" | sed "s/file/${csv}/g" )"
  echo "${scriptImport}" | sqlite3 "${database}"
}

#
# Index les valeurs des nombres premiers pour accélérer la recherche
#
primeDB_setup_indexValues(){
  database="${1:-${primeDB_DATABASE?}}"
  scriptIndex="${2:-${primeDB_SQL_INDEX?}}"

  echo ".. INFO Index database values"
  cat "${scriptIndex}" | sqlite3 "${database}"
}
