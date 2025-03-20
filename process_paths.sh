#!/bin/bash

# Check for command-line argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <list_file>"
  exit 1
fi

LIST_FILE="$1"
OUTPUT_FILE="processed_paths.txt"
TODO_DIR="todo"

if [ ! -f "$LIST_FILE" ]; then
  echo "Error: List file '$LIST_FILE' not found."
  exit 1
fi

while read -r stripped_line <&3; do

  categories=()
  existing_path=$(echo "$stripped_line" | awk -F'"' '{print $2}') # Default path

  # Determine Category Contexts and longest Alternate existing path
  for strip_file in *.strip; do
    line_num=$(grep -n "^$stripped_line$" "$strip_file" | cut -d: -f1)
    if [[ -n "$line_num" ]]; then
      category="${strip_file%.strip}"
      categories+=("${category}")
      new_path=$(sed -n "${line_num}p" "$category" | awk -F'"' '{print $2}')
      if [[ ${#new_path} -gt ${#existing_path} ]]; then
        existing_path="$new_path"
      fi
    fi
  done

  # Search Unprocessed Files for Additional Contexts
  for todo_file in "$TODO_DIR"/*; do
    if grep -q "^$stripped_line$" "$todo_file"; then
      categories+=("$(basename "$todo_file")")
    fi
  done


  # Verify Path with all known Categories as Context
  if [[ ${#categories[@]} -gt 0 ]]; then
    echo -n "Existing path [${categories[*]}]: "
  else
    echo -n "Existing path [UNKNOWN]: "
  fi
  echo "\"$existing_path\""
  read -p "Enter desired path (or leave blank to continue): " desired_path
  echo "work \"${desired_path:-$existing_path}\" $(echo "${stripped_line}" | awk '{$1=$2=""; print $0}')" >> "$OUTPUT_FILE"
done 3< "$LIST_FILE"

echo "Processing complete. Results in $OUTPUT_FILE"
