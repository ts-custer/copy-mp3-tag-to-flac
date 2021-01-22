#!/bin/bash

# Script to copy tags of all audio files of a source directory to all files of the current directory
#
# Usage: copy_audio_tags <Source Directory> [-t]
# If you set option -t ('test mode'), nothing will be saved.
#
#

#################### FUNCTIONS:

function initiate() {

  test_mode=0

  if [ "${number_of_parameters}" -eq 1 ]; then
    directory="${1}"
  else
    if [ "${1}" = "-t" ]; then
      test_mode=1
      directory="${2}"
    fi

    if [ "${2}" = "-t" ]; then
      test_mode=1
      directory="${1}"
    fi
  fi
}


function check_directory() {
  if [ ! -d "${directory}" ]; then
    echo "Directory \"${directory}\" does not exist!"
    exit 1
  fi
}


function initiate_target_files() {
  target_files=($(get_files_sorted "."))
  number_of_target_files=${#target_files[@]}

  if [ "${number_of_target_files}" -eq 0 ]; then
    echo "The current directory doesn't contain any files!"
    exit 1
  else
    echo "${number_of_target_files} files in current directory found."
  fi
}


function initiate_source_files() {
  source_files=($(get_files_sorted "${directory}"))
  number_of_source_files=${#source_files[@]}

  if [ "${number_of_source_files}" -lt "${number_of_target_files}" ]; then
    echo "The source directory \"${directory}\" contains only ${number_of_source_files} files!"
    exit 1
  else
    echo "${number_of_source_files} files in source directory \"${directory}\" found."
  fi
}


function get_files_sorted() {
  local directory="${1}"

  for filename in $(find "${directory}" -maxdepth 1 -type f | sort); do
    echo "${filename}"
  done
}


function safety_break() {
  local x=$(shuf -i 1-9 -n 1)
  read -r -p "Enter '${x}' to proceed.. " y

  if [ "${y}" != "${x}" ] # user entered nothing or something else than x
  then
    stop
  fi
}


function stop() {
  echo "Execution stopped, nothing saved!"
  exit 0
}


function execute() {

  for ((i = 0; i < ${number_of_target_files}; i++))
  do
    echo "copy_mp3_tag_to_flac.py \"${source_files[$i]}\" \"${target_files[$i]}\""
    if [ "${test_mode}" -eq 0 ]
    then
      $(copy_mp3_tag_to_flac.py "${source_files[$i]}" "${target_files[$i]}")
    fi
  done

  if [ "${test_mode}" -eq 1 ]
  then
    echo "Nothing saved because of test mode (-t)."
  fi
}



#################### START:

declare test_mode
declare directory
declare -a target_files
declare number_of_target_files
declare -a source_files
declare number_of_source_files
declare number_of_parameters

number_of_parameters="${#}"

if [ "${number_of_parameters}" -lt 1 ]; then
  echo "Usage: copy_audio_tags <Source Directory> [-t]"
  echo "If you set option -t ('test mode'), nothing will be saved."
  exit 1
else
  initiate "${1}" "${2}"
  check_directory
  ifs_old=${IFS}
  IFS=$'\n'
  initiate_target_files
  initiate_source_files
  if [ "${test_mode}" -eq 0 ]
  then
    safety_break
  fi
  execute
  IFS=${ifs_old}
fi
