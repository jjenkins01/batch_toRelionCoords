#!/bin/bash
# bash script to automate toRelionCoords from model and motive lists generated using createAlignedModel.
# Step 1: Run createAlignedModel.
# Step 2: Copy the files generated from createAlignedModel into motive list and model directories.
# Step 3: Modify the tomogram dimensions and output star file name below.
# Step 4: Run this script! "./script_name.sh"

# Define tomogram dimensions. This relates to the bin4 tomogram generated in Warp
tomosize="[1024,1024,376]" # Tomogram dimensions as a string

# Define the output STAR file name
output_star_file="combined_star_file.star" # Output .STAR file to store the results

# Define the directories containing the model and motive list files
# Update the paths below to match the location of your model and motive list files

# Path to the directory containing the model files (e.g. .mod files)
model_dir="models/"  # Update with the correct path to your model files

# Path to the directory containing the motive list files (e.g. .csv files)
motive_list_dir="motive_lists/"  # Update with the correct path to your motive list files

# Initialize a flag to track if the header has been processed
header_processed=false

# Function to run toRelionCoords for a model and motive list pairing
run_to_relion_coords() {
    local model="$1"       # Input model file
    local motive_list="$2" # Input motive list file
    
    # Create a temporary file to store new data from toRelionCoords
    temp_file=$(mktemp)

    # Run toRelionCoords and store output in the temporary file
    toRelionCoords "$model" "$motive_list" "$tomosize" "$temp_file"
    
    # Append data from the temporary file to the output STAR file
    if [ "$header_processed" = false ]; then
        # Include the whole temporary file (including header and data)
        cat "$temp_file" >> "$output_star_file"
        # Set the flag to true since the header has been processed
        header_processed=true
    else
        # Append only particle data (lines starting with "tomo" or similar) to the output STAR file
        awk 'BEGIN {skip=true} /^loop_/ {skip=false} /^tomo[0-9]/ && !skip {print}' "$temp_file" >> "$output_star_file"
    fi

    # Remove the temporary file
    rm -f "$temp_file"
}

# Main script
# Initialise the output STAR file by emptying it
echo "" > "$output_star_file"

# Loop through all model files in the specified model directory sorted in natural numerical order
for model_file in $(ls "$model_dir"/*.mod | sort -V); do
    # Extract the model name from the file path
    model_name=$(basename "$model_file" .mod)
    
    # Define the corresponding motive list file path
    motive_list_file="$motive_list_dir/${model_name}.csv"
    
    # Check if the motive list file exists
    if [ -f "$motive_list_file" ]; then
        # Run the function to perform the conversion
        run_to_relion_coords "$model_file" "$motive_list_file"
    else
        echo "Warning: Motive list file not found for model $model_name"
    fi
done

echo "Conversion completed. All results saved in $output_star_file"

