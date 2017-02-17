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


