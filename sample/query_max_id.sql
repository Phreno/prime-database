--
-- PrimeDB - Récupère l'index du plus grand prime contenu dans la BDD
--

-- ======================
-- INFORMATIONS GÉNÉRALES
-- ======================

-----------------------
-- MODIFIE LA BASE: NON
-----------------------

-- Date........ samedi 15 avril 2017, 15:46:56 (UTC+0200)
-- Objectifs... Déterminer les limites de la base
-- Intention... Limiter le champ de recherche
-- Etat........ TESTED

------------------
-- Commentaires --
------------------
-- N/A

SELECT max(rowid)
FROM prime;
