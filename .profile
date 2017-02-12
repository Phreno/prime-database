# [K3rn€l_P4n1k]
export primeDB=$(pwd)
export primeDB_DATA_FOLDER=${primeDB}/data
export primeDB_ARCHIVE=${primeDB}/.data.tar

export primeDB_PADDING="%05d"
export primeDB_CARTOUCHE_HEIGHT=2
export primeDB_COLUMNS=8


debug(){
  source .profile
  echo "TEST primeDB_chunk_getName()"
  primeDB_chunk_getName
  primeDB_chunk_getName 1
  primeDB_chunk_getName 003
  primeDB_chunk_getName 055
  
  echo "TEST primeDB_chunk_getCartouche"
  primeDB_chunk_getCartouche
  primeDB_chunk_getCartouche 1
  primeDB_chunk_getCartouche 003
  primeDB_chunk_getCartouche 055

  echo "TEST primeDB_chunk_getLine"
  primeDB_chunk_getLine 
  primeDB_chunk_getLine 1 1
  primeDB_chunk_getLine 3 3
  primeDB_chunk_getLine 55 55

  echo "TEST primeDB_chunk_getOffsetFromLine"
  primeDB_chunk_getOffsetFromLine 1
  primeDB_chunk_getOffsetFromLine 2
  primeDB_chunk_getOffsetFromLine 3
  
  primeDB_chunk_getOffsetFromLine 1 10
}

###########
# SERVICE #
###########

# Récupère le nom d'une archive en fonction de son index
primeDB_chunk_getName(){
  indice=${1:-1}
  chunkName=$( printf "${primeDB_DATA_FOLDER}/${primeDB_PADDING}.zip" ${indice})
  echo $chunkName
}

# Récupère le cartouche d'une portion
primeDB_chunk_getCartouche(){
  indice=${1:-1}
  cartouche=$(unzip -qq -c $( primeDB_chunk_getName ${indice} ) | head -n 1)
  echo ${cartouche}
}

# Récupère la nième ligne d'une portion
primeDB_chunk_getLine(){
  indice=${1:-1}
  line=${2:-1}
  result=$(unzip -qq -c $( primeDB_chunk_getName ${indice} ) | head -n $((${line}+${primeDB_CARTOUCHE_HEIGHT})) | tail -n 1)
  echo ${result}
}

# Récupère le nième terme d'une ligne
primeDB_chunk_getOffsetFromLine(){
  offset=${1:-1}
  line=${2:-1}
  chunk=${3:-1}
  echo $(primeDB_chunk_getLine $chunk $line ) | awk -v n=${offset} '{print $n}'
}

# TODO
# lineMin
# lineMax
# chunkMin
# chunkMax
# primesBetween
# isPrime
# primesAround
# getNth

#########
# SETUP #
#########

# Installe la base de données des nombres premiers
primeDB_setup(){
  echo ".. INFO setup primeDB"
  primeDB_removeData
  primeDB_downloadPrimes
  primeDB_cleanFolder
  primeDB_normalizeDatafileName
  primeDB_backupData
  echo ".. INFO setup done"
}

# Télécharge tous les fichier zip disponibles à l'URL 
# indiquée dans le dossier passé en paramètre
primeDB_downloadPrimes(){
  folder=${1:-${primeDB_DATA_FOLDER}}
  url="http://primes.utm.edu/lists/small/millions"
  format="zip"
  echo ".. INFO download primes archive from ${url} into ${folder}"
  wget -P ${folder} -r -np -nd -l 1 -A ${format} ${url}
  echo ".. INFO download done"
}

# Supprime les fichiers inutiles
primeDB_cleanFolder(){
  folder=${1:-${primeDB_DATA_FOLDER}}
  useless="robots.txt"
  echo ".. INFO clean prime data folder from useless files"
  rm ${folder}/${useless}
  echo ".. INFO clean done"
}

# Désinstalle la banque de données
primeDB_removeData(){
  folder=${1:-${primeDB_DATA_FOLDER}}
  echo ".. INFO delete primes data"
  rm -rf ${folder}
  echo ".. INFO delete done"
}

# Sauvegarde les données
primeDB_backupData(){
  folder=$( basename ${1:-${primeDB_DATA_FOLDER}} )
  archive=${2:-${primeDB_ARCHIVE}}
  echo ".. INFO backup data into ${archive}"
  tar cvf ${archive} ${folder}
  echo ".. INFO backup done"
}

# Restaure les données
primeDB_restoreData(){
  primeDB_removeData
  archive=${2:-${primeDB_ARCHIVE}}
  echo ".. INFO restore backup from ${archive}"
  tar xvf ${archive}
  echo ".. INFO restore done"
}


# Normalise les indices suffixées sur les noms de fichier
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
