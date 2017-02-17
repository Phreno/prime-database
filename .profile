#!/bin/sh
# ..............
# [K3rn€l_P4n1k]
# ..............

# =======================
# FOLDER & FILE MANAGMENT
# =======================

#
# BASE folder
#
export primeDB="$(pwd)"

#
# DATA
#
export primeDB_DATA_FOLDER="${primeDB}/data"
for chunk in "${primeDB_DATA_FOLDER}/*.zip";
do
  export $( echo primeDB_CHUNK_$( echo basename ${chunk%.zip} ))="${chunk}"
done;

#
# BIN
#
export primeDB_BIN_FOLDER="${primeDB}/bin"
export primeDB_CORE="${primeDB_BIN_FOLDER}/core.sh"
export primeDB_SERVICE="${primeDB_BIN_FOLDER}/service.sh"

#
# LIB
#
export primeDB_LIB_FOLDER="${primeDB_BIN_FOLDER}/lib"
export primeDB_ERROR="${primeDB_LIB_FOLDER}/error.sh"

#
# TEST
#
export primeDB_TEST_FOLDER="${primeDB}/test"
export primeDB_TEST_CORE="${primeDB_TEST_FOLDER}/debug_core.sh"
export primeDB_TEST_SERVICE="${primeDB_TEST_FOLDER}/debug_service.sh"

#
# ARCHIVE
#
export primeDB_ARCHIVE="${primeDB}/.data.tar"

# =========
# CONSTANTS
# =========

# Padding utilisé pour nommer les chunks
export primeDB_PADDING="%05d"

# Chaque chunk dispose d'un header de 2 lignes
export primeDB_CARTOUCHE_HEIGHT=2

# Il y à 8 nombres premiers sur chaque ligne
export primeDB_COLUMNS=8

# Le nombre total de ligne dans un chunk
export primeDB_CHUNK_SIZE=125002  # Including cartouche

# Le nombre de ligne dans un chunk
export primeDB_CHUNK_LINES=125000 # Without cartouche
