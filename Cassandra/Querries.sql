--querries:

--Requêtes simples (Normal filters, projection et comptage) :


--Lister tous les restaurants dans le Bronx :
SELECT * FROM restaurants WHERE borough = 'Bronx';

--Lister le nom et le type de cuisine de tous les restaurants avec une note supérieure à 8 :
SELECT name, cuisine FROM restaurants WHERE grades[0].score > 8;

--Compter le nombre total de restaurants à Brooklyn :
SELECT COUNT(*) FROM restaurants WHERE borough = 'Brooklyn';



--Lister le nom et le quartier des 5 premiers restaurants dans Manhattan :
SELECT name, borough FROM restaurants WHERE borough = 'Manhattan' LIMIT 5;

--Afficher les noms des restaurants et leur code postal dans Queens avec une note supérieure à 10 :
SELECT name, addresses.zipcode FROM restaurants WHERE borough = 'Queens' AND grades[0].score > 10;

--Afficher le nombre total de grades attribués à tous les restaurants :

SELECT SUM(SIZE(grades)) AS total_grades FROM restaurants;




--Requêtes complexes (Filtres forts, agrégats, géolocalisation) :

--Trouver les restaurants avec des coordonnées géographiques dans un rayon de 1 kilomètre autour d'un point spécifique (longitude, latitude) :
SELECT * FROM restaurants WHERE FILTER(geodistance(coord['coordinates'][0], coord['coordinates'][1], long, lat) < 1);

--Calculer la moyenne des scores pour chaque quartier :

SELECT borough, AVG(grades[0].score) AS avg_score FROM restaurants GROUP BY borough;


--Requête difficile (Agrégats complexes, combinaison avec des filtres, transformation, MapReduce) :

--Calculer la moyenne des scores pour chaque type de cuisine dans chaque quartier, en excluant les scores inférieurs à 5 et en classant les résultats par quartier et type de cuisine :
SELECT borough, cuisine, AVG(grades[0].score) AS avg_score
FROM restaurants
WHERE grades[0].score > 5
GROUP BY borough, cuisine
ORDER BY borough, cuisine;

