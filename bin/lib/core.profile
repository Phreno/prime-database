########
# CORE #
########


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

