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
  chunkPathTemplate="${primeDB_DATA_DIR}/${primeDB_DATA_PADDING}.${primeDB_DATA_FORMAT}"
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
primeDB_CORE_listChunksFiles(){
  ls -1 ${primeDB_DATA_DIR}/*.zip
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

#
# Récupère le chunk au sein duquel est contenu le nombre
#
primeDB_CORE_getCandidateChunk(){
  entry=${1:-1}
  guess=${2:-1}
  limit=${3:-"$( primeDB_CORE_countChunks )"}

  while [ ${entry} -ge $( primeDB_CORE_chunk_getMinPrime ${guess} ) ]; do
    guess=$(( $guess + 1 ))
    if [ "${guess}" -gt "${limit}" ]; then
      echo "ERR primeDB_CORE_getCandidateChunk: guess growing up"
      exit 1
    fi
  done

  echo "${guess}"
}

# FIXME: La recherche linéaire est beaucoup trop lente
# 
# Récupère la ligne au sein de laquelle est contenu le nombre
#
primeDB_CORE_chunk_getCandidateLine_linear(){
  chunk=${1:-1}
  entry=${2:-1}
  guess=${3:-1}
  limit=${4:-${primeDB_CHUNK_LINES}}
  first=$( primeDB_CORE_chunk_line_getMinPrime ${chunk} ${guess} )
  while [ $(( ${entry} )) -ge $(( ${first} )) ]; do
    guess=$(( guess + 1 ))
    first=$( primeDB_CORE_chunk_line_getMinPrime ${chunk} ${guess} )
  done
  echo $(( ${guess} -1 ))
}


# TODO
# Essai en dichotomique
#

#1 Indice entier i, l, r
#2 l = 1
#3 r = N
#4 i = b(l + r)/2c
#5 while ((k 6= T[i]) ∧ (l ≤ r)) do
#6 if (k < T[i]) then
#7 r = i − 1
#8 else
#9 l = i + 1
#10 i = b(l + r)/2c
#11 if (k == T[i]) then
#12 retourner i
#13 else
#14 retourner −1

primeDB_CORE_chunk_getCandidatLine(){
  chunk=${1:-1}
  search=${2:-1}

  left=1
  right=${primeDB_CHUNK_LINES}
  index= $(( (${left} + ${right}) / 2 ))
}

# TODO
# Est ce qu'un nombre se situe sur une ligne
#
# Est situé sur la ligne, tout nombre
# dont la valeur est comprise entre la première valeur de la ligne,
# et la première valeur de la ligne suivante.
primeDB_CORE_chunk_line_isIncludedIn(){
  chunk=${1:-1}
  line=${2:-1}
  value=${3:-1}

  start=$( primeDB_CORE_chunk_line_getMinPrime ${chunk} ${line} )
  end=$( primeDB_CORE_chunk_line_getMinPrime ${chunk} $(( ${line} + 1 )) )

  result=-1
  if [ ${value} -ge ${start} ] && [ ${value} -lt ${end} ]; then
    result=${value}
  fi
  echo ${result}
}


# TODO
# Est ce qu'un nombre est premier
#
primeDB_CORE_isPrime(){
  value=${1:-1}
  chunk=$( primeDB_CORE_getCandidateChunk ${value} )
  line=$( primeDB_CORE_chunk_getCandidateLine ${chunk} ${value} )
  echo ${line}
}

