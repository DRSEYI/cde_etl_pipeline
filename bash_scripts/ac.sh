#!/bin/bash

echo "e dey work"


RAW_DIR="data/raw"
PROCESSED_DIR="data/transformed"
GOLD_DIR="data/gold"

#create folder if it does not exist
if [ ! -d "$RAW_DIR" ];then
        mkdir -p "$RAW_DIR"
        echo "Created: $RAW_DIR"
else
        echo "folder already exists :$RAW_DIR"
fi


#Download the data from the already set environment variable.The link is in the source url
wget -O "$RAW_DIR/survey23.csv" "$SOURCE_URL"

echo "download completed"

if  [ ! -d "$PROCESSED_DIR" ]; then
        mkdir -p "$PROCESSED_DIR"
        echo " $PROCESSED_DIR :folder created"
else
        echo "Folder  already exist"
fi

##copy the raw file to the transformed folder

sed '1s/Variable_code/variable_code/' "$RAW_DIR/survey23.csv" > "$PROCESSED_DIR/transformed.csv"


#select the four columns and add them to create a new file

awk -F',' '
BEGIN{
        OFS=","
 }
NR == 1 {
        for (i=1; i<=NF; i++){
                if ($i=="Year") Year=i
                if ($i=="Value") Value=i
                if ($i=="Units") Units=i
                if ($i=="variable_code") variable_code=i

        }
     }
      {print $Year,$Value,$Units,$variable_code
}
' "$PROCESSED_DIR/transformed.csv" > "$PROCESSED_DIR/2023_year_finance.csv" && echo "Finance file successfully created"
