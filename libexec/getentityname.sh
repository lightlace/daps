#!/bin/bash
# Find names of referenced entity files

allentities=''
while [[ "$1" ]]; do
  # Assume that 10000 characters is enough space for the beginning of the
  # document. Might not be true if you put a huge comment at the beginning of
  # the document.
  filestart=$(head -c 10000 "$1" | tr '\n' ' ' | grep -oP '^(<\?.*\?>|<!--.*?-->|\s)*(<!DOCTYPE\s+[\w\d]+(\s+\[.*?\])?.*?>)?' | grep -oP '(\[.*?\])?.*?>$' | tr \' \")
  entities=$(echo "$filestart" | grep -oP '<!ENTITY.*?>' | sed -r 's/<!ENTITY[^"]+"([^"]+)".*$/\1/')
  allentities+="$entities\n"
  shift
done

echo -e "$allentities" | sort | uniq | sed -n '/^[^$]/ p'
