-- 
-- PrimeDB - Sélection des nombres premiers jumeaux
--

-- ======================
-- INFORMATIONS GÉNÉRALES
-- ======================

-----------------------
-- MODIFIE LA BASE: NON 
-----------------------

-- Date........ samedi 15 avril 2017, 00:49:54 (UTC+0200)
-- Objectifs... Récupérer la suite des nombres premiers jumeaux
-- Intention... Créer un premier fichier d'exemple
-- Etat........ TESTED

------------------
-- Commentaires --
------------------
-- N/A

.separator ;
SELECT 	  p1.value
	, p2.value
 
FROM 	prime AS p1
	INNER JOIN prime AS p2 ON p1.value = p2.value - 2
;
