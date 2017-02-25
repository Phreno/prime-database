#!/bin/bash
# ..............
# [K3rn€l_P4n1k]
# ..............

# ============
# CORE_PROFILE
# ============
#
# Utilitaire de travail sur les chunks

primeDB_CORE_PROFILE="${BASH_SOURCE[0]:-$(realpath ${0})}"
primeDB_CORE_PROFILE_DIR="$( dirname ${primeDB_CORE_PROFILE} )"

#
# Récupère le nom d'une archive en fonction de son index
#
primeDB_CORE_chunk_getPath(){
  chunkIndex=${1:-1}
  chunkPathTemplate="${primeDB_DATA_DIR}/${primeDB_DATA_PADDING}.${primeDB_DATA_COMPRESSION}"
  echo "$( printf ${chunkPathTemplate} ${chunkIndex} )"
}

#
# Récupère le chunk correspondant à l'index
#
primeDB_CORE_chunk_get(){
  chunkIndex=${1:-1}
  chunk=$(primeDB_CORE_chunk_getPath ${chunkIndex})
  unzip -qq -c ${chunk}
}

#
# Récupère le cartouche d'une portion
#
primeDB_CORE_chunk_getCartouche(){
  chunkIndex=${1:-1}
  headerSize=${primeDB_CARTOUCHE_HEIGHT}
  echo "$( primeDB_CORE_chunk_get ${chunkIndex} | head -n ${headerSize} )"
}

#
# Récupère la nième ligne d'une portion
#
primeDB_CORE_chunk_getLine(){
  chunkIndex=${1:-1}
  line=${2:-1}
  cursor=$(( ${line} + ${primeDB_CARTOUCHE_HEIGHT} ))
  echo "$( primeDB_CORE_chunk_get ${chunkIndex} | head -n ${cursor} | tail -n 1 )"
}

#
# Récupère le nième terme d'une ligne
#
primeDB_CORE_chunk_line_getPrime(){
  chunkIndex=${1:-1}
  line=${2:-1}
  offset=${3:-1}
  echo $(primeDB_CORE_chunk_getLine $chunkIndex $line ) | awk -v n=${offset} '{print $n}'
}

#
# Récupère la valeur maximum d'une ligne
#
primeDB_CORE_chunk_line_getMaxPrime(){
  chunkIndex=${1:-1}
  line=${2:-1}
  offset=${3:-${primeDB_COLUMNS}}
  primeDB_CORE_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

#
# Récupère la valeur minimum d'une ligne
#
primeDB_CORE_chunk_line_getMinPrime(){
  chunkIndex=${1:-1}
  line=${2:-1}
  offset=${3:-1}

  primeDB_CORE_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

#
# Récupère la valeur minimum d'un chunk
#
primeDB_CORE_chunk_getMinPrime(){
  chunkIndex=${1:-1}
  line=1
  offset=1
  primeDB_CORE_chunk_line_getPrime ${chunkIndex} ${line} ${offset}
}

#
# Récupère la valeur maximum d'un chunk
#
primeDB_CORE_chunk_getMaxPrime(){
  chunkIndex=${1:-1}
  offset=${primeDB_COLUMNS}
  primeDB_CORE_chunk_get ${chunkIndex} | tail -n 1 | awk -v n=${offset} '{print $n}'
}

#
# Compte le nombre de ligne d'un chunk
#
primeDB_CORE_chunk_countLines(){
  chunkIndex=${1:-1}
  headerSize=${primeDB_CARTOUCHE_HEIGHT}
  allLines=$( primeDB_CORE_chunk_get ${chunkIndex} | wc -l )
  echo $(( ${allLines} - ${headerSize} ))
}

#
# Liste les chunk disponibles
#
primeDB_CORE_listChunksFil(){
  l -1 ${primeDB_DATA_DIR}/*.zip
}

#
# Liste le nom des chunks disponibles
#
primeDB_CORE_listChunksNames(){
  for l in $(find ${primeDB_DATA_DIR} -type f -exec basename {} \; | sort); do
    echo ${l%.zip}
  done
}

#
# Compte les chunks disponibles
#
primeDB_CORE_countChunks(){
  primeDB_CORE_listChunksFiles | wc -l
}

#
# Récupère la valeur du plus haut prime
#
primeDB_CORE_getMaxPrime(){
  primeDB_CORE_chunk_getMaxPrime $(primeDB_CORE_countChunks)
}

#
# Récupère le nième élément d'un chunk
#
primeDB_CORE_chunk_getNth(){
  chunk=${1:-1}
  nth=${2:-1}
  stepBack=$(( ${nth} - 1 ))
  offset=$(( ${stepBack} % ${primeDB_COLUMNS} ))
  line=$(( ${stepBack} / ${primeDB_COLUMNS} ))
  lineCursor=$(( ${line} + 1 ))
  offsetCursor=$(( ${offset} + 1 ))
  primeDB_CORE_chunk_line_getPrime ${chunk} ${lineCursor} ${offsetCursor}
}
