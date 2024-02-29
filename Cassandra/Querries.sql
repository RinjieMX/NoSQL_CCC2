--queries:

-------------------- Requêtes simples (Normal filters, projection et comptage) :

--Lister tous les restaurants dans le Bronx :
CREATE INDEX borough_index on restaurants(borough);
DROP INDEX IF EXISTS borough_index;
SELECT * FROM restaurants WHERE borough = 'Bronx';

-- Lister les restaurants japonais et leur quartier
SELECT name, borough FROM restaurants WHERE cuisine='Japanese' ALLOW FILTERING;

--Compter le nombre total de restaurants à Brooklyn :
SELECT COUNT(*) FROM restaurants WHERE borough = 'Brooklyn';

--Lister le nom et le quartier des 5 premiers restaurants dans Manhattan :
SELECT name, borough FROM restaurants WHERE borough = 'Manhattan' AND cuisine = 'Pizza' LIMIT 5 ALLOW FILTERING;

--Afficher le nombre total de grades attribués à tous les restaurants :
SELECT COUNT(*) FROM grades;

-- Afficher les notes d'un restaurant en particulier
SELECT grade, score FROM grades WHERE restaurant_id ='41701180';


------------------------- Requêtes complexes (Filtres forts, agrégats, géolocalisation) :

-- Compter le nombre de restaurants par quartier :
SELECT borough, COUNT(*) AS total FROM restaurants_by_borough GROUP BY borough;

--Lister le nom et le type de cuisine de tous les restaurants avec une note A :
SELECT name, cuisine, last_grade, last_score FROM restaurants_with_scores WHERE last_grade = 'A' ALLOW FILTERING;

--Calculer la moyenne des scores pour chaque restaurant :
SELECT restaurant_id, AVG(score) AS avg_score FROM grades GROUP BY restaurant_id;


------------------------ Requête difficile (Agrégats complexes, combinaison avec des filtres, transformation, MapReduce) :

--UDA (GROUP BY + COUNT de valeurs textuelles)
CREATE OR REPLACE FUNCTION update_count_state(state map<text, int>, value text)
RETURNS NULL ON NULL INPUT
RETURNS map<text, int>
LANGUAGE java AS '
  if (!state.containsKey(value)) {
    state.put(value, 1);
  } else {
    state.put(value, state.get(value) + 1);
  }
  return state;
';

CREATE OR REPLACE AGGREGATE group_by_count(text)
SFUNC update_count_state
STYPE map<text, int>
INITCOND {};

SELECT group_by_count(cuisine) FROM restaurants;
