#!/bin/bash

# Function to format the directory path
format_path() {
  local IFS='/'
  read -ra path_array <<< "$PWD"
  local length=${#path_array[@]}
  local formatted_path=""

  for (( i=0; i<length; i++ )); do
    if (( length - i > 3 )); then
      # Abbreviate directories more than three levels up to 1 character
      formatted_path+="${path_array[i]:0:1}/"
    else
      # Keep the last three directories as is
      formatted_path+="${path_array[i]}/"
    fi
  done

  # Remove trailing slash
  formatted_path="${formatted_path%/}"

  echo "$formatted_path"
}

# Call the function and output the result
format_path
