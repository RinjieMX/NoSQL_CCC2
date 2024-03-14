import json
import os
from datetime import datetime

def timestamp_to_date(timestamp):
    dt_object = datetime.utcfromtimestamp(timestamp / 1000)  # Convertir de millisecondes en secondes
    formatted_date = dt_object.strftime('%Y-%m-%d')  # Format DD/MM/YYYY
    return formatted_date

current_dir = os.path.dirname(os.path.abspath(__file__))
input_file_path = os.path.join(current_dir, '..', 'RestaurantsInspections.json', 'restaurants.json')
output_file_path = os.path.join(current_dir, '..', 'RestaurantsInspections.json', 'restaurants_fixed_elastic.json')

with open(input_file_path, 'r') as input_file, open(output_file_path, 'w') as output_file:
    # Lire chaque ligne du fichier
    for line in input_file:
        # Charger la ligne en tant qu'objet JSON
        document = json.loads(line)

        # Convertir les timestamps en dates pour chaque grade (en supprimant le sous-attribut $date)
        for grade in document["grades"]:
            grade["date"] = timestamp_to_date(grade["date"]["$date"])

        # Préparer le préfixe d'indexation avec l'_id correspondant au restaurant_id du document
        index_prefix = {
            "index": {
                "_index": "restaurants",
                "_id": int(document["restaurant_id"])
            }
        }
        # Écrire le préfixe d'indexation et le document au fichier de sortie
        output_file.write(json.dumps(index_prefix) + '\n')
        output_file.write(json.dumps(document) + '\n')
