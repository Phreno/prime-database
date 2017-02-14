# [K3rn€l_P4n1k]
export primeDB=$(pwd)
export primeDB_DATA_FOLDER=${primeDB}/data
export primeDB_ARCHIVE=${primeDB}/.data.tar

export primeDB_PADDING="%05d"
export primeDB_CARTOUCHE_HEIGHT=2
export primeDB_COLUMNS=8
export primeDB_CHUNK_SIZE=125002

# TODO
# primesBetween
# isPrime
# primesAround
# getNth

###########
# SERVICE #
###########
debug_service(){
  source .profile

}


########
# CORE #
########
debug_core(){
  source .profile
  echo "TEST primeDB_chunk_getPath()"
  primeDB_chunk_getPath
  primeDB_chunk_getPath 1
  primeDB_chunk_getPath 003
  primeDB_chunk_getPath 055
  
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

  echo "TEST primeDB_chunk_line_getPrime"
  primeDB_chunk_line_getPrime 1
  primeDB_chunk_line_getPrime 2
  primeDB_chunk_line_getPrime 3 
  primeDB_chunk_line_getPrime 1 10
  primeDB_chunk_line_getPrime 3 3 3

  echo "TEST primeDB_chunk_line_getMinPrime"
  primeDB_chunk_line_getMinPrime
  primeDB_chunk_line_getMinPrime 1 1
  primeDB_chunk_line_getMinPrime 3 78

  echo "TEST primeDB_chunk_line_getMaxPrime"
  primeDB_chunk_line_getMaxPrime 
  primeDB_chunk_line_getMaxPrime 1 1
  primeDB_chunk_line_getMaxPrime 3 78

  echo "TEST primeDB_chunk_getMinPrime"
  primeDB_chunk_getMinPrime 1
  primeDB_chunk_getMinPrime 2
  primeDB_chunk_getMinPrime 3

  echo "TEST primeDB_chunk_getMaxPrime"
  primeDB_chunk_getMaxPrime 1
  primeDB_chunk_getMaxPrime 2
  primeDB_chunk_getMaxPrime 3

  echo "TEST primeDB_chunk_countLines"
  primeDB_chunk_countLines 1
  primeDB_chunk_countLines 2
  primeDB_chunk_countLines 3

  echo "TEST primeDB_listChunksFiles"
  primeDB_listChunksFiles

  echo "TEST primeDB_listChunksNames"
  primeDB_listChunksNames

  echo "TEST primeDB_countChunks"
  primeDB_countChunks
}


# Récupère le nom d'une archive en fonction de son index
primeDB_chunk_getPath(){
  chunkIndex=${1:-1}
  chunkName=$( printf "${primeDB_DATA_FOLDER}/${primeDB_PADDING}.zip" ${chunkIndex})
  echo $chunkName
}

# Récupère le chunk correspondant à l'index
primeDB_chunk_get(){
 chunkIndex=${1:-1}
 unzip -qq -c $(primeDB_chunk_getPath ${chunkIndex})
}

# Récupère le cartouche d'une portion
primeDB_chunk_getCartouche(){
  chunkIndex=${1:-1}
  cartouche=$( primeDB_chunk_get ${chunkIndex} | head -n ${primeDB_CARTOUCHE_HEIGHT} )
  echo ${cartouche}
}

# Récupère la nième ligne d'une portion
primeDB_chunk_getLine(){
  chunkIndex=${1:-1}
  line=${2:-1}
  result=$( primeDB_chunk_get ${chunkIndex} | head -n $((${line}+${primeDB_CARTOUCHE_HEIGHT})) | tail -n 1 )
  echo ${result}
}

# Récupère le nième terme d'une ligne
primeDB_chunk_line_getPrime(){
  chunkIndex=${1:-1}
  line=${2:-1}
  offset=${3:-1}
  echo $(primeDB_chunk_getLine $chunkIndex $line ) | awk -v n=${offset} '{print $n}'
}

# Récupère la valeur maximum d'une ligne
primeDB_chunk_line_getMaxPrime(){
  chunkIndex=${1:-1}
  line=${2:-1}
  offset=${primeDB_COLUMNS}
  primeDB_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

# Récupère la valeur minimum d'une ligne
primeDB_chunk_line_getMinPrime(){
  chunkIndex=${1:-1}
  line=${1:-1}
  offset=1
  primeDB_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

# Récupère la valeur minimum d'un chunk
primeDB_chunk_getMinPrime(){
  chunkIndex=${1:-1}
  line=1
  offset=1
  primeDB_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

# Récupère la valeur maximum d'un chunk
primeDB_chunk_getMaxPrime(){
  chunkIndex=${1:-1}
  offset=${primeDB_COLUMNS}
  primeDB_chunk_get ${chunkIndex} | tail -n 1 | awk -v n=${offset} '{print $n}'
}

# Compte le nombre de ligne d'un chunk
primeDB_chunk_countLines(){
  chunkIndex=${1:-1}
  primeDB_chunk_get ${chunkIndex} | wc -l
}

# Liste les chunk disponibles
primeDB_listChunksFiles(){
  ls -1 ${primeDB_DATA_FOLDER}/*.zip
}

# Liste le nom des chunks disponibles
primeDB_listChunksNames(){
  for l in $(find ${primeDB_DATA_FOLDER} -type f -exec basename {} \; | sort); do
    echo ${l%.zip}
  done
}

# Compte les chunks disponibles
primeDB_countChunks(){
  primeDB_listChunksFiles | wc -l
}

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
