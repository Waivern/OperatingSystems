#!/bin/bash
# De eerste parameter is de directory waar de foto’s staan.
echo $1
# De tweede parameter bestaat uit de aanduiding “maand” of “week”.
echo $2

if [ $2 != "week" ] && [ $2 != "maand" ]; then
    echo "Parameter 2 is niet of niet goed ingevuld"
else
    if [ -d "$1" ]; then
        TELLER=0
        if [ $2 == "week" ]; then
            AFBEELDINGEN=$(find "$1" -iname "*.jpg" -o -iname "*.png" -atime +7)
        fi
        if [ $2 == "maand" ]; then
            AFBEELDINGEN=$(find "$1" -iname "*.jpg" -o -iname "*.png" -atime +30)
        fi
        echo "Afbeeldingen: $AFBEELDINGEN"

        AANTAL=$(echo "$AFBEELDINGEN" | wc -l)
        echo "$AANTAL"
        for X in $AFBEELDINGEN; do
            TELLER=$((TELLER + 1))
            clear
            # week of maandnummers mappen aanmaken
            if [ $2 == "week" ]; then
                DATUM=$(date -r "$X" +%W)
            fi
            if [ $2 == "maand" ]; then
                DATUM=$(date -r "$X" +"%m%y")
            fi
            echo "$X"
            echo "Kopiëren van afbeelding $X naar fotos/$DATUM"
            echo "Voortgang: $TELLER van $AANTAL"
            # Als map nog niet bestaat dan aanmaken
            mkdir -p "fotos/$DATUM"
            cp "$X" "fotos/$DATUM"
            FILE1=$(md5sum $X | awk '{ print $1 }')
            BESTAND=$(basename $X)
            BESTAND2=$(find fotos/$DATUM -name "$BESTAND")
            FILE2=$(md5sum $BESTAND2 | awk '{ print $1 }')
            echo "$FILE1 en $FILE2"
            if [[ $FILE2 == $FILE1 ]]; then
                echo "$BESTAND = $FILE1 en $FILE2 . Bestand 1 wordt nu verwijderd."
                rm $X
            fi
            sleep 2
        done
    else
        echo "Parameter 1: $1 is geen folder of symbolische link"
    fi
fi
