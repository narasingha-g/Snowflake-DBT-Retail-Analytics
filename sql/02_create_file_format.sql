use database portfolio_db;


--Step1 : Create the file format
/*create or replace file format csv_format 
type = csv 
field_optionally_enclosed_by='"'
skip_header =1
field_delimiter=','
null_if=('NULL','','null'); */

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
TYPE = CSV
COMPRESSION = AUTO
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
PARSE_HEADER = TRUE
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TRIM_SPACE = TRUE
NULL_IF = ('NULL', '')
EMPTY_FIELD_AS_NULL = TRUE;

show file formats;

DESC FILE FORMAT CSV_FORMAT;

-- Step 2: create an internal stage
create or replace stage retail_stage
file_format=csv_format;

show stages;

--Step3: Upload the files in portfolio_dbPORTFOLIO_DB.RAW.RETAIL_STAGE

list @retail_stage;


