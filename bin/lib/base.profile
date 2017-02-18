#!/bin/sh
# ..............
# [K3rn€l_P4n1k]
# ..............

primeDB_BASE_PROFILE="${BASH_SOURCE[0]:-$(realpath ${0})}"
primeDB_BASE_PROFILE_DIR="$( dirname ${primeDB_BASE_PROFILE} )"

# ==========
# SETUP NEED
# ==========

#
# PRIMES LOCATION
#
export primeDB_ZIP_URL="http://primes.utm.edu/lists/small/millions"

# =========
# CONSTANTS
# =========


#
# Chaque chunk dispose d'un header de 2 lignes
#
export primeDB_CARTOUCHE_HEIGHT=2

#
# Il y à 8 nombres premiers sur chaque ligne
#
export primeDB_COLUMNS=8

#
# Le nombre total de ligne dans un chunk
#
export primeDB_CHUNK_SIZE=125002  # Including cartouche

#
# Le nombre de ligne dans un chunk
#
export primeDB_CHUNK_LINES=125000 # Without cartouche

# =======================
# DIR & FILE MANAGMENT
# =======================

#
# DATA
#
export primeDB_DIR="${primeDB_BASE_PROFILE_DIR/\/bin\/lib/}"
# Location des chunks
export primeDB_DATA_DIR="${primeDB_DIR}/data"
# Compression des chunks
export primeDB_DATA_FORMAT="zip"
# Padding utilisé pour nommer les chunks
export primeDB_DATA_PADDING="%05d"

#TODO FIXME export chunkFiles
# chunkFiles="${primeDB_DATA_DIR}/*.${primeDB_DATA_FORMAT}"
#
# for chunk in $chunkFiles;
# do
#  chunkName="$( basename ${chunk%.${primeDB_DATA_FORMAT}} )"
#  echo $chunkName
#  export $( echo primeDB_CHUNK_${chunkName} )="${chunk}"
# done;
# echo "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
# exit 1;

#
# BIN
#
export primeDB_BIN_DIR="${primeDB_DIR}/bin"
export primeDB_CORE="${primeDB_BIN_DIR}/core.sh"
export primeDB_SERVICE="${primeDB_BIN_DIR}/service.sh"

#
# LIB
#
export primeDB_LIB_DIR="${primeDB_BIN_DIR}/lib"
export primeDB_ERROR="${primeDB_LIB_DIR}/error.sh"

#
# TEST
#
export primeDB_TEST_DIR="${primeDB_DIR}/test"
export primeDB_TEST_CORE="${primeDB_TEST_DIR}/debug_core.sh"
export primeDB_TEST_SERVICE="${primeDB_TEST_DIR}/debug_service.sh"

#
# ARCHIVE
#
export primeDB_ARCHIVE="${primeDB_DIR}/.data.tar"
