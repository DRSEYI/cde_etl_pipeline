This project implements an automated ETL pipeline using Bash, `wget`, `sed`, `awk` and cron. The pipeline downloads the financial  dataset,
stores the original file in a raw-data layer, applies a column transformation, extracts selected columns and publishes the resulting dataset to a gold (serving) layer.
