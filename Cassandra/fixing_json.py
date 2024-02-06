import os

# Script to repair the JSON format of the provided file

current_dir = os.path.dirname(os.path.abspath(__file__))
json_file_path = os.path.join(current_dir, '..', 'RestaurantsInspections.json', 'restaurants.json')
fixed_json_file_path = os.path.join(current_dir, '..', 'RestaurantsInspections.json', 'restaurants_fixed.json')

def fix_json_format(file_path, output_path):
    try:
        # Read the entire content of the original file
        with open(file_path, 'r') as file:
            content = file.read().strip()
        
        # Assuming the file contains multiple JSON objects separated by whitespace/newline
        # Combine them into a single JSON array
        fixed_content = "[" + ",".join(content.split('\n')) + "]"
        
        # Write the fixed content to a new file
        with open(output_path, 'w') as fixed_file:
            fixed_file.write(fixed_content)
            
        return True, output_path  # Return success status and the path to the fixed file
    except Exception as e:
        return False, str(e)  # Return failure status and the error message

# Attempt to fix the JSON format and get the result
result, message = fix_json_format(json_file_path, fixed_json_file_path)
print(result, message)