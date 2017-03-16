#!/bin/bash

# ..............................................................
# [K3rn€l_P4n1k] - primeDB_setup/base.profile - 1.0 - 2017.02.26
# ..............................................................

# Description
#
# Fournit les constantes de base pour l'installation

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

#
# Le nombre de nombres premiers par chunks
#
export primeDB_CHUNK_COUNT=1000000


# ====================
# DIR & FILE MANAGMENT
# ====================

#
# DATA
#
export primeDB_DIR="${primeDB_BASE_PROFILE_DIR/\/lib/}"
# Location des chunks
export primeDB_DATA_DIR="${primeDB_DIR}/data"
# Compression des chunks
export primeDB_DATA_COMPRESSION="zip"
# Extension des fichier après décompression
export primeDB_DATA_EXT="txt"
# Padding utilisé pour nommer les chunks
export primeDB_DATA_PADDING="%05d"
# Location de la base de données
export primeDB_DATABASE="${primeDB_DATA_DIR}/primeDB.db"
# Fichier d'import de la base de données
export primeDB_IMPORT="${primeDB_DATA_DIR}/import.csv"


#
# BIN
#
export primeDB_BIN_DIR="${primeDB_DIR}/bin"
export primeDB_CORE="${primeDB_BIN_DIR}/core.sh"
export primeDB_SERVICE="${primeDB_BIN_DIR}/service.sh"

#
# LIB
#
export primeDB_LIB_DIR="${primeDB_DIR}/lib"
export primeDB_ERROR="${primeDB_LIB_DIR}/error.sh"

#
# SQL
#
export primeDB_SQL_DIR="${primeDB_DIR}/sql"
export primeDB_SQL_CREATE="${primeDB_SQL_DIR}/db_create.sql"
export primeDB_SQL_INSERT="${primeDB_SQL_DIR}/db_insert.sql"
export primeDB_SQL_IMPORT="${primeDB_SQL_DIR}/db_import.sql"
export primeDB_SQL_INDEX="${primeDB_SQL_DIR}/db_index.sql"

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
