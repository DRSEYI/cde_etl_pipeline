#!/bin/bash

#==========================================================================

# CDE_ETL ASSIGNMENT 
# Author: Seyi
# Purpose: Download survey data, standardise columns,
# extract finance metrics and load into gold layer.

#===========================================================================

#Stops the script when  there is any error
 
set  -euo pipefail


#Define the directories for each of the  layers
RAW_DIR="data/raw"
PROCESSED_DIR="data/transformed"
GOLD_DIR="data/gold"

#create  the directories and the -p prevents error if the dictories already exist.

mkdir -p "$RAW_DIR" "$PROCESSED_DIR" "$GOLD_DIR"


#Download dataset using the SOURCE_URL environment variable.The file is saved as survey23.csv
wget -O "$RAW_DIR/survey23.csv" "$SOURCE_URL"  && echo "Download completed"



##Standardise the variable_code column  name 

sed '1s/Variable_code/variable_code/' "$RAW_DIR/survey23.csv" > "$PROCESSED_DIR/transformed.csv"


#Extract the Year,Value,Units,variable_code  columns and save in a new file.

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
' "$PROCESSED_DIR/transformed.csv" > "$PROCESSED_DIR/2023_year_finance.csv" && echo "Transformation completed and ready for shipping"

#Copy the transformed  folder to the gold layer and renamed as gold.csv
cp "$PROCESSED_DIR/2023_year_finance.csv" "$GOLD_DIR/gold.csv"  && echo "Gold data published: $GOLD_DIR/"






