--
-- PrimeDB - Récupère le plus grand nombre premier de la base de données
--

-- ======================
-- INFORMATIONS GÉNÉRALES
-- ======================

-----------------------
-- MODIFIE LA BASE: NON
-----------------------

-- Date........ samedi 15 avril 2017, 15:53:20 (UTC+0200)
-- Objectifs... Déterminer la limite de la base
-- Intention... Limiter le champ de recherche
-- Etat........ TESTED

------------------
-- Commentaires --
------------------
-- N/A

SELECT max(value)
FROM prime;
