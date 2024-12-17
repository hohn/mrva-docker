import os
import json

# Input and output file paths
input_file = "metadata.json"
output_file = "filtered_metadata.json"

# Read the metadata file line by line
with open(input_file, "r") as infile:
    lines = infile.readlines()

filtered_lines = []

for line in lines:
    try:
        # Parse the line as JSON
        data = json.loads(line.strip())
        # Extract the tail of the result_url
        result_url_tail = os.path.basename(data.get("result_url", ""))
        # Check if a file with the same name exists in the current directory
        if os.path.isfile(result_url_tail):
            filtered_lines.append(line)
    except json.JSONDecodeError:
        print(f"Skipping invalid JSON line: {line.strip()}")

# Write the filtered lines to the output file
with open(output_file, "w") as outfile:
    outfile.writelines(filtered_lines)

print(f"Filtered metadata saved to {output_file}")
