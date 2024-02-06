from cassandra.cluster import Cluster
import json
from datetime import datetime

# Connexion à Cassandra
cluster = Cluster(['127.0.0.2'])  # Assurez-vous que l'adresse IP est correcte
session = cluster.connect('resto_inspec')

# Lecture du fichier JSON corrigé
with open('restaurants_fixed.json', 'r') as f:
    data = json.load(f)

# Insertion des données dans la table restaurants
for item in data:
    # Insertion dans la table restaurants
    query_restaurant = """
    INSERT INTO restaurants (restaurant_id, name, borough, cuisine)
    VALUES (%s, %s, %s, %s)
    """
    session.execute(query_restaurant, (item['restaurant_id'], item['name'], item['borough'], item['cuisine']))
    
    # Insertion dans la table addresses
    address = item['address']
    coord_type = address['coord']['type']
    coordinates = address['coord']['coordinates']
    coord_X = float(coordinates[0])
    coord_Y = float(coordinates[1])
    query_address = """
    INSERT INTO addresses (address_id, building, street, zipcode, coord_type, coord_X, coord_Y)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    session.execute(query_address, (item['restaurant_id'], address['building'], address['street'], address['zipcode'], coord_type, coord_X, coord_Y))

    # Insertion dans la table grades
    for grade in item['grades']:
        # Conversion du timestamp en millisecondes en un objet datetime
        date = datetime.utcfromtimestamp(grade['date']['$date'] / 1000)  # Divisez par 1000 pour convertir en secondes
        query_grade = """
        INSERT INTO grades (restaurant_id, date, grade, score)
        VALUES (%s, %s, %s, %s)
        """
        session.execute(query_grade, (item['restaurant_id'], date, grade['grade'], grade['score']))
