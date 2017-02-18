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


