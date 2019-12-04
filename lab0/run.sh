
RANGE=50
while true; do
    sleep 1 ;
    # random logs
    max=$(( ( RANDOM % $RANGE )  + 1 ))
    for (( i=1; i<$max; i++ ))
    do
        ts=$(date +"%Y/%m/%d %H:%M:%S")
        echo "$ts lab1 - background message in random code: $RANDOM";
    done

done