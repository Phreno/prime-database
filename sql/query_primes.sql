-- Développeur ....: K3rn€l_P4n1K
-- Nom ............: PrimeDB/select_primes
-- Description ....: Récupère la liste des nombres premiers disponibles en base de données
-- Version ........: 1.0
-- Date ...........: dimanche 16 avril 2017, 16:46:18 (UTC+0200)
-- Dépendances ....: PrimeDB
-- État ...........: Utilisable
-- Fonctionnalité .: Liste les premiers
-- Intention ......: Faciliter le requêtage de la base
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

-- This file is part of PrimeDB.
--
-- PrimeDB is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- PrimeDB is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with PrimeDB. If not, see <http://www.gnu.org/licenses/>.

.separator ;
SELECT value
FROM prime;
.next
