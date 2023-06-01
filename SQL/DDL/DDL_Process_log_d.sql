CREATE OR REPLACE TABLE `paid-project-346208`.meta_ds.`Process_log_d`
(
ID STRING NOT NULL,
Process_name STRING,
Started TIMESTAMP NOT NULL,
Finished TIMESTAMP,
Truncated INT64,
Inserted INT64, 
`Update` INT64,
Status STRING,
Started_By STRING,
Error STRING
);