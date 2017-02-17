#!/bin/sh

primeDB_test_CORE_chunk_getPath(){
  echo "TEST __primeDB_CORE_chunk_getPath()"
  __primeDB_CORE_chunk_getPath
  __primeDB_CORE_chunk_getPath 1
  __primeDB_CORE_chunk_getPath 003
  __primeDB_CORE_chunk_getPath 055
}


primeDB_test_CORE_chunk_getCartouche(){
  echo "TEST __primeDB_CORE_chunk_getCartouche"
  __primeDB_CORE_chunk_getCartouche
  __primeDB_CORE_chunk_getCartouche 1
  __primeDB_CORE_chunk_getCartouche 003
  __primeDB_CORE_chunk_getCartouche 055
}


primeDB_test_CORE_chunk_getLine(){ 
  echo "TEST __primeDB_CORE_chunk_getLine"
  __primeDB_CORE_chunk_getLine 
  __primeDB_CORE_chunk_getLine 1 1
  __primeDB_CORE_chunk_getLine 3 3
  __primeDB_CORE_chunk_getLine 55 55
}


primeDB_test_CORE_chunk_line_getPrime (){
  echo "TEST __primeDB_CORE_chunk_line_getPrime"
  __primeDB_CORE_chunk_line_getPrime 1
  __primeDB_CORE_chunk_line_getPrime 2
  __primeDB_CORE_chunk_line_getPrime 3 
  __primeDB_CORE_chunk_line_getPrime 1 10
  __primeDB_CORE_chunk_line_getPrime 3 3 3
}

primeDB_test_CORE_chunk_line_getMinPrim(){
  echo "TEST __primeDB_CORE_chunk_line_getMinPrime"
  __primeDB_CORE_chunk_line_getMinPrime
  __primeDB_CORE_chunk_line_getMinPrime 1 1
  __primeDB_CORE_chunk_line_getMinPrime 3 78
}



primeDB_test_CORE_chunk_line_getMaxPrime(){ 
  echo "TEST __primeDB_CORE_chunk_line_getMaxPrime"
  __primeDB_CORE_chunk_line_getMaxPrime 
  __primeDB_CORE_chunk_line_getMaxPrime 1 1
  __primeDB_CORE_chunk_line_getMaxPrime 3 78
}


  





primeDB_test_CORE_chunk_getMinPrime (){
  echo "TEST __primeDB_CORE_chunk_getMinPrime"
  __primeDB_CORE_chunk_getMinPrime 1
  __primeDB_CORE_chunk_getMinPrime 2
  __primeDB_CORE_chunk_getMinPrime 3
}

primeDB_test_CORE_chunk_getMaxPrime (){
  echo "TEST __primeDB_CORE_chunk_getMaxPrime"
  __primeDB_CORE_chunk_getMaxPrime 1
  __primeDB_CORE_chunk_getMaxPrime 2
  __primeDB_CORE_chunk_getMaxPrime 3
}



primeDB_test_CORE_chunk_countLines (){
  echo "TEST __primeDB_CORE_chunk_countLines"
  __primeDB_CORE_chunk_countLines 1
  __primeDB_CORE_chunk_countLines 2
  __primeDB_CORE_chunk_countLines 3
}



primeDB_test_CORE_listChunksFile(){
  echo "TEST __primeDB_CORE_listChunksFiles"
  __primeDB_CORE_listChunksFiles
}


primeDB_test_CORE_listChunksName(){
echo "TEST __primeDB_CORE_listChunksNames"
  __primeDB_CORE_listChunksNames
}


primeDB_test_CORE_countChunk(){
echo "TEST __primeDB_CORE_countChunks"
  __primeDB_CORE_countChunks
}



primeDB_test_CORE_getMaxPrim(){
echo "TEST __primeDB_CORE_getMaxPrime"
  __primeDB_CORE_getMaxPrime
}



primeDB_test_CORE_chunk_getNt(){
echo "TEST __primeDB_CORE_chunk_getNth"
  __primeDB_CORE_chunk_getNth
  __primeDB_CORE_chunk_getNth 1
  __primeDB_CORE_chunk_getNth 1 1
  __primeDB_CORE_chunk_getNth 1 2
  __primeDB_CORE_chunk_getNth 1 8
  __primeDB_CORE_chunk_getNth 1 9
}


primeDB_test_CORE(){

}



