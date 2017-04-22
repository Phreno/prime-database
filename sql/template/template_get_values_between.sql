-- Développeur ....: K3rn€l_P4n1K
-- Nom ............: PrimeDB/template_get_value
-- Description ....: Donne la suite des nombres premiers contenus entre deux valeurs
-- Version ........: 1.0
-- Date ...........: samedi 22 avril 2017, 09:43:32 (UTC+0200)
-- Dépendances ....: PrimeDB
-- État ...........: Utilisable
-- Fonctionnalité .: Fournit un modèle de données à remplir
-- Intention ......: Génération de script sql
-- Remarque .......: AUCUN

-----------------------
-- MODIFIE LA BASE: NON
-----------------------

------------------
-- Commentaires --
------------------
-- AUCUN

-- ===========================
-- Copyright 2017 K3rn€l P4n1k
-- ===========================

-- This file is part of primeDB.
--
-- primeDB is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- primeDB is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with primeDB. If not, see <http://www.gnu.org/licenses/>.

SELECT value
FROM prime
WHERE
value >=#min_value AND
value <=#max_value;
.quit
