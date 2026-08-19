text=$(date +%H:%M-%d/%m/%Y)
IFS='-' read -r -a array <<< "$text"

echo -e " ${array[0]}    ${array[1]}"
