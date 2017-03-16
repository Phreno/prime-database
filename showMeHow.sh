#!/bin/bash

# Développeur ....: K3rn€l_P4n1K
# Description ....: testClient - 1.0 - Thu Mar 16 11:31:41 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Test manuel de vérification du script client
# Intention ......: Tester le client et montrer son utilisation
# Remarque .......: 

# ------------------
# VARIABLES GLOBALES
# ------------------

# Chemin du script
SCRIPT="${0}"

# Nom du script
SCRIPT_NAME="$( basename ${0} )"

# Dossier du script
SCRIPT_DIR="$( dirname ${0} )"

# Fichier de log des erreurs
LOGERR="${SCRIPT_NAME}.err.log"

# ---------
# FONCTIONS
# ---------

# Exécutée lors de la sortie du script (CTRL+C par exemple)
onExit(){
    displayLog
}
trap onExit EXIT


# Exécutée lors d'une erreur 
onError(){
    echo ".. ERR: dans le script ${SCRIPT_NAME}" >> ${LOGERR}
}
trap onError ERR

# Affiche les logs le cas échéant
displayLog(){
    if [ -s "${LOGERR}" ]; then
        echo ".. ERR: Sortie du script ${SCRIPT_NAME}"
        cat "${LOGERR}" 
    fi
    rm -f "${LOGERR}"
}

# Vérifie si les fichiers en entrées sont des fichiers valide
checkFile(){
    file="${1}"
    if [ ! -s "${file}" ]; then
        echo "${file} n'existe pas" >> "${LOGERR}"
        exit 1
    fi
}

# Test la fonctionnalité nth
test_nth(){
  echo "> Récupération du nombre premier à la position donnée"
  for index in `seq 1 1 10`; do 
    echo "node ${CLIENT} -n ${index} => `node "${CLIENT}" -n "${index}"`"
  done
  echo ""
}

test_prime(){
  echo "> Est-ce que le nombre donné en paramètre est premier"
  for index in `seq 1 1 10`; do
    echo "node ${CLIENT} -p ${index} => `node "${CLIENT}" -p "${index}"`" 
  done
  echo ""
}

# Test la fonctionnalité position
test_position(){
  echo "> Indique la position de nombre premier données en paramètre"
  for index in `seq 1 1 10`; do
    echo "node ${CLIENT} -i ${index} => `node "${CLIENT}" -i "${index}"`"
  done
  echo ""
}

# Test les fonctionnalitées coffeeScript
testAll(){
  test_nth
  test_prime
  test_position
}

# --------------
# INITIALISATION
# --------------
CLIENT="./public/client/index.js"

# -----------
# TRAITEMENTS
# -----------

checkFile "${CLIENT}"
testAll
