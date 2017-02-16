# [K3rn€l_P4n1k]

# TODO
# split into many files
# ensure args 
# catch error
export primeDB=$(pwd)
export primeDB_DATA_FOLDER=${primeDB}/data
export primeDB_ARCHIVE=${primeDB}/.data.tar

export primeDB_PADDING="%05d"
export primeDB_CARTOUCHE_HEIGHT=2
export primeDB_COLUMNS=8
export primeDB_CHUNK_SIZE=125002  # Including cartouche
export primeDB_CHUNK_LINES=125000 # Without cartouche
# TODO
# primesBetween
# isPrime
# primesAround
# getNth
# Next
# Previous
# closer

###########
# SERVICE #
###########
debug_service(){
  source .profile
  echo "TEST primeDB_getNth"
  primeDB_getNth
  primeDB_getNth 1
  primeDB_getNth 2
  primeDB_getNth 8
  primeDB_getNth 9
  primeDB_getNth 500000
}


# FIXME
primeDB_getNth(){
  nth=${1:-1}
  echo "nth $nth"
  
  offset=$(( ${nth} % ${primeDB_COLUMNS} ))
  echo "offset $offset"
  
  line=$(( ${nth} / ${primeDB_COLUMNS} ))
  echo "line $line"
  
  chunk=$(( ${line} / ${primeDB_CHUNK_LINES} +1 ))
  echo "chunk $chunk"
  
  line=$(( ${line} % ${chunk} +1 ))
  echo "line $line"
  echo $(__primeDB_CORE_chunk_line_getPrime ${chunk} ${line} ${offset})
}



########
# CORE #
########
debug_core(){
  source .profile
  echo "TEST __primeDB_CORE_chunk_getPath()"
  __primeDB_CORE_chunk_getPath
  __primeDB_CORE_chunk_getPath 1
  __primeDB_CORE_chunk_getPath 003
  __primeDB_CORE_chunk_getPath 055
  
  echo "TEST __primeDB_CORE_chunk_getCartouche"
  __primeDB_CORE_chunk_getCartouche
  __primeDB_CORE_chunk_getCartouche 1
  __primeDB_CORE_chunk_getCartouche 003
  __primeDB_CORE_chunk_getCartouche 055

  echo "TEST __primeDB_CORE_chunk_getLine"
  __primeDB_CORE_chunk_getLine 
  __primeDB_CORE_chunk_getLine 1 1
  __primeDB_CORE_chunk_getLine 3 3
  __primeDB_CORE_chunk_getLine 55 55

  echo "TEST __primeDB_CORE_chunk_line_getPrime"
  __primeDB_CORE_chunk_line_getPrime 1
  __primeDB_CORE_chunk_line_getPrime 2
  __primeDB_CORE_chunk_line_getPrime 3 
  __primeDB_CORE_chunk_line_getPrime 1 10
  __primeDB_CORE_chunk_line_getPrime 3 3 3

  echo "TEST __primeDB_CORE_chunk_line_getMinPrime"
  __primeDB_CORE_chunk_line_getMinPrime
  __primeDB_CORE_chunk_line_getMinPrime 1 1
  __primeDB_CORE_chunk_line_getMinPrime 3 78

  echo "TEST __primeDB_CORE_chunk_line_getMaxPrime"
  __primeDB_CORE_chunk_line_getMaxPrime 
  __primeDB_CORE_chunk_line_getMaxPrime 1 1
  __primeDB_CORE_chunk_line_getMaxPrime 3 78

  echo "TEST __primeDB_CORE_chunk_getMinPrime"
  __primeDB_CORE_chunk_getMinPrime 1
  __primeDB_CORE_chunk_getMinPrime 2
  __primeDB_CORE_chunk_getMinPrime 3

  echo "TEST __primeDB_CORE_chunk_getMaxPrime"
  __primeDB_CORE_chunk_getMaxPrime 1
  __primeDB_CORE_chunk_getMaxPrime 2
  __primeDB_CORE_chunk_getMaxPrime 3

  echo "TEST __primeDB_CORE_chunk_countLines"
  __primeDB_CORE_chunk_countLines 1
  __primeDB_CORE_chunk_countLines 2
  __primeDB_CORE_chunk_countLines 3

  echo "TEST __primeDB_CORE_listChunksFiles"
  __primeDB_CORE_listChunksFiles

  echo "TEST __primeDB_CORE_listChunksNames"
  __primeDB_CORE_listChunksNames

  echo "TEST __primeDB_CORE_countChunks"
  __primeDB_CORE_countChunks

  echo "TEST __primeDB_CORE_getMaxPrime"
  __primeDB_CORE_getMaxPrime

  echo "TEST __primeDB_CORE_chunk_getNth"
  __primeDB_CORE_chunk_getNth
  __primeDB_CORE_chunk_getNth 1
  __primeDB_CORE_chunk_getNth 1 1
  __primeDB_CORE_chunk_getNth 1 2
  __primeDB_CORE_chunk_getNth 1 8
  __primeDB_CORE_chunk_getNth 1 9
}


# Récupère le nom d'une archive en fonction de son index
__primeDB_CORE_chunk_getPath(){
  chunkIndex=${1:-1}
  chunkName=$( printf "${primeDB_DATA_FOLDER}/${primeDB_PADDING}.zip" ${chunkIndex})
  echo $chunkName
}

# Récupère le chunk correspondant à l'index
__primeDB_CORE_chunk_get(){
 chunkIndex=${1:-1}
 unzip -qq -c $(__primeDB_CORE_chunk_getPath ${chunkIndex})
}

# Récupère le cartouche d'une portion
__primeDB_CORE_chunk_getCartouche(){
  chunkIndex=${1:-1}
  cartouche=$( __primeDB_CORE_chunk_get ${chunkIndex} | head -n ${primeDB_CARTOUCHE_HEIGHT} )
  echo ${cartouche}
}

# Récupère la nième ligne d'une portion
__primeDB_CORE_chunk_getLine(){
  chunkIndex=${1:-1}
  line=${2:-1}
  result=$( __primeDB_CORE_chunk_get ${chunkIndex} | head -n $((${line}+${primeDB_CARTOUCHE_HEIGHT})) | tail -n 1 )
  echo ${result}
}

# Récupère le nième terme d'une ligne
__primeDB_CORE_chunk_line_getPrime(){
  chunkIndex=${1:-1}
  line=${2:-1}
  offset=${3:-1}
  echo $(__primeDB_CORE_chunk_getLine $chunkIndex $line ) | awk -v n=${offset} '{print $n}'
}

# Récupère la valeur maximum d'une ligne
__primeDB_CORE_chunk_line_getMaxPrime(){
  chunkIndex=${1:-1}
  line=${2:-1}
  offset=${primeDB_COLUMNS}
  __primeDB_CORE_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

# Récupère la valeur minimum d'une ligne
__primeDB_CORE_chunk_line_getMinPrime(){
  chunkIndex=${1:-1}
  line=${1:-1}
  offset=1
  __primeDB_CORE_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

# Récupère la valeur minimum d'un chunk
__primeDB_CORE_chunk_getMinPrime(){
  chunkIndex=${1:-1}
  line=1
  offset=1
  __primeDB_CORE_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

# Récupère la valeur maximum d'un chunk
__primeDB_CORE_chunk_getMaxPrime(){
  chunkIndex=${1:-1}
  offset=${primeDB_COLUMNS}
  __primeDB_CORE_chunk_get ${chunkIndex} | tail -n 1 | awk -v n=${offset} '{print $n}'
}

# Compte le nombre de ligne d'un chunk
__primeDB_CORE_chunk_countLines(){
  chunkIndex=${1:-1}
  allLines=__primeDB_CORE_chunk_get ${chunkIndex} | wc -l
  echo $(( ${allLine} - ${primeDB_CARTOUCHE_HEIGHT} ))
}

# Liste les chunk disponibles
__primeDB_CORE_listChunksFiles(){
  ls -1 ${primeDB_DATA_FOLDER}/*.zip
}

# Liste le nom des chunks disponibles
__primeDB_CORE_listChunksNames(){
  for l in $(find ${primeDB_DATA_FOLDER} -type f -exec basename {} \; | sort); do
    echo ${l%.zip}
  done
}

# Compte les chunks disponibles
__primeDB_CORE_countChunks(){
  __primeDB_CORE_listChunksFiles | wc -l
}

# Récupère la valeur du plus haut prime
__primeDB_CORE_getMaxPrime(){
  __primeDB_CORE_chunk_getMaxPrime $(__primeDB_CORE_countChunks)
}

# TODO
# chunk_getNth
__primeDB_CORE_chunk_getNth(){
  echo "========================================================"
  chunk=${1:-1}
  
  nth=${2:-1}
  echo "chunk $chunk - nth $nth"

  offset=$(( ${nth} % ${primeDB_COLUMNS} ))

  line=$(( ${nth} / $line ))
  echo "chunk $chunk - line $line - offset $offset" 
  __primeDB_CORE_chunk_line_getPrime ${chunk} ${line} ${offset}
  echo "--------------------------------------------------------"
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
