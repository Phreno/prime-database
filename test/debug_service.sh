#!/bin/bash
# ..............
# [K3rn€l_P4n1k]
# ..............

# =============
# DEBUG_SERVICE
# =============
#
# Test les fonctions d'exploitation des chunks

primeDB_DEBUG_SERVICE_SH="${BASH_SOURCE[0]:-$(realpath ${0})}"
primeDB_DEBUG_SERVICE_SH_DIR="$( dirname ${primeDB_DEBUG_CORE_SH} )"

primeDB_test_SERVIVE_chunk_getNth(){
  echo "TEST primeDB_getNth"
  for pr in $( seq 1 1000000 50000000 ); do
    for i in $( seq $pr 1 16 ); do
      pri=$(( $pr + $i ))
      echo "[$pri] $( ../bin/primeDB_getNth $pri )"
    done
  done
}

runAll(){
  primeDB_test_SERVIVE_chunk_getNth
}

runAll
