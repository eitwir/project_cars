CREATE OR REPLACE PROCEDURE `paid-project-346208.car_ads_ds_staging_test.cars_com_card_tokenized_300_Dima_first_version`()
BEGIN 
	
	DECLARE inserted_task_id INT64;
	DECLARE task_id INT64;
	
	CALL `paid-project-346208`.meta_ds.usp_write_log_Maksym(null, "cars_com_card_tokenized_300_Dima_first_version", 
	'Started', inserted_task_id);

	SET task_id = inserted_task_id;
 
  TRUNCATE TABLE `paid-project-346208`.car_ads_ds_staging_test.`cars_com_card_tokenized_300_Dima`;
	
	INSERT INTO `paid-project-346208`.car_ads_ds_staging_test.`cars_com_card_tokenized_300_Dima` 
		(card_id, brand, model, `year`, price_history, price_usd, adress, state, zip_code, home_delivery, virtual_appointments, included_warranty, VIN, transmission, 
		transmission_type, engine, engine_vol,
		fuel, mpg, milage, milage_unit, body, drive, color, one_owner, accidents_or_damage, clean_title, personal_use_only, comment, scrap_date, source_id, 
		dl_loaded_date) 

SELECT
		--SAFE_CAST(GENERATE_UUID() AS STRING) as row_id, 
		SAFE_CAST(card_id AS STRING) AS card_id , 
		CASE 
			WHEN SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1,2) AS STRING) = 'Land' Then 'Land Rover'
			WHEN SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1,2) AS STRING) = 'Alfa' Then 'Alfa Romeo'
			WHEN SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1,2) AS STRING) = 'Am' Then 'Am General'
			WHEN SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1,2) AS STRING) = 'American' Then 'American Motors'
			WHEN SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1,2) AS STRING) = 'Aston' Then 'Aston Martin'
			WHEN SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1,2) AS STRING) = 'Avanti' Then 'Avanti Motors'
			ELSE SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1,2) AS STRING) 
		END as brand,
		SAFE_CAST(REGEXP_REPLACE(title, r'^(\S+) (\S+) ', '') AS STRING) as model, 
		--REPLACE(model, 'Rover ', ''), 
		SAFE_CAST(REGEXP_EXTRACT(title, r'(\S+)', 1) AS INT64) as `year`, 
		SAFE_CAST(price_history AS STRING) as price_history,
		SAFE_CAST(REGEXP_REPLACE(price_primary, r'[^0-9]+', '') AS int64) AS price_usd,
		SAFE_CAST(REGEXP_REPLACE(location, r', (\S+ \S+)', '') AS STRING) as adress,
		CASE 
			WHEN SAFE_CAST(REGEXP_EXTRACT(location, r', (\S+)') AS STRING) is NULL
			THEN SAFE_CAST('' as STRING)
			ELSE SAFE_CAST(REGEXP_EXTRACT(location, r', (\S+)') AS STRING)
		END as state,
		CASE
			WHEN SAFE_CAST(REGEXP_EXTRACT(location, r' (\d{5})') AS STRING) is NULL
			THEN SAFE_CAST('' as STRING)
			ELSE SAFE_CAST(REGEXP_EXTRACT(location, r' (\d{5})') AS STRING)
		END as zip_code,
		CASE 
			WHEN REGEXP_EXTRACT(labels, r'Home Delivery') LIKE 'Home Delivery' THEN SAFE_CAST('Y' AS STRING)
			ELSE SAFE_CAST('N' AS STRING)
		END AS home_delivery,
		CASE 
			WHEN REGEXP_EXTRACT(labels, r'Virtual Appointments') LIKE 'Virtual Appointments' THEN SAFE_CAST('Y' AS STRING)
			ELSE SAFE_CAST('N' AS STRING)
		END as virtual_appointments,
		CASE 
			WHEN REGEXP_EXTRACT(labels, r'Included warranty') LIKE 'Included warranty' THEN SAFE_CAST('Y' AS STRING)
			ELSE SAFE_CAST('N' AS STRING)
		END as included_warranty,
SAFE_CAST(REGEXP_EXTRACT(labels, r'VIN: (\S{17})') AS STRING) as VIN,
SAFE_CAST(split(description, ',')[1] as STRING) as transmission, --if NULL duplicate the value from transmission_type?
		CASE 
			WHEN REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') like 'Automatic,'
			THEN SAFE_CAST(SUBSTRING(REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)'), 1,
			LENGTH(REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)')) - 1) as STRING)
			WHEN REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') like 'Manual,'
			THEN SAFE_CAST(SUBSTRING(REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)'), 1,
			LENGTH(REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)')) - 1) as STRING)
			WHEN REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') like 'A/T'
			THEN SAFE_CAST('Automatic' as STRING)
			WHEN REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') like 'M/T'
			THEN SAFE_CAST('Manual' as STRING)
			WHEN REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') like 'w/Dual'
			THEN SAFE_CAST('Automatic' as STRING)
			WHEN REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') like 'CVT'
			THEN SAFE_CAST('Automatic' as STRING)
			WHEN REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') like 'Auto'
			THEN SAFE_CAST('Automatic' as STRING)
			WHEN REGEXP_EXTRACT(description, r'(Variable)') like 'Variable'
			THEN SAFE_CAST('Variable' as STRING)
			WHEN REGEXP_EXTRACT(description, r'(Turbo)') like 'Turbo'
			THEN SAFE_CAST('Automatic' as STRING)
			ELSE SAFE_CAST(REGEXP_EXTRACT(description, r'([AM]/[T]|[A][u]\S+|[M][a][n]\S+|w/\S+|CVT)') as STRING)
		END as transmission_type,
		SAFE_CAST(split(description, ',')[2] as STRING) as engine,
		CASE 
			WHEN SAFE_CAST(REGEXP_EXTRACT(description, r'(\d{1}.\d{1})L') as float64) * 1000 is not NULL
			THEN SAFE_CAST(SAFE_CAST(REGEXP_EXTRACT(description, r'(\d{1}.\d{1})L') as float64) * 1000 as int64)
			ELSE 0
		END as engine_vol,
		REGEXP_EXTRACT(split(description, ',')[3], r'([A-Z]\w+)') as fuel,
		CASE
			WHEN SAFE_CAST(REGEXP_EXTRACT(description,r'[(](\S+)') as STRING) is NULL
			THEN SAFE_CAST('' as STRING)
			ELSE SAFE_CAST(REGEXP_EXTRACT(description,r'[(](\S+)') as STRING)
		END as mpg, 
		CASE
			WHEN SAFE_CAST(REPLACE(REGEXP_EXTRACT(description, r'(\d+ \d+) mi.'), ' ', '') as INT64) is NULL
			THEN SAFE_CAST(REGEXP_EXTRACT(description,r'(\d+) mi') as int64)
			ELSE SAFE_CAST(REPLACE(REGEXP_EXTRACT(description, r'(\d+ \d+) mi.'), ' ', '') as INT64)
		END as mileage,
		CASE 
			WHEN REGEXP_EXTRACT(description, r'mi') like 'mi'
			THEN SAFE_CAST('mile' as STRING)
			ELSE NULL
		END as milage_unit,
		CASE
			WHEN REGEXP_EXTRACT(description, r'mi. . (\S* \S+),') is NULL
			THEN SAFE_CAST(REGEXP_EXTRACT(description, r'mi. . (\S+),') as STRING)
			ELSE SAFE_CAST(REGEXP_EXTRACT(description, r'[|] (\w+.\S+),') as STRING)
		END  as body,
		CASE
			WHEN SAFE_CAST(REGEXP_EXTRACT(description, r'[|] \w+.\S+, (\w+.\S+ Drive)') as STRING) is NULL
			THEN SAFE_CAST(REGEXP_EXTRACT(description, r'(.[W][D])') as STRING)
			--WHEN SAFE_CAST(REGEXP_EXTRACT(description, r'(.[W][D])') as STRING) like 'FWD'
			--THEN SAFE_CAST('Front-wheel Drive' as STRING)
			--WHEN SAFE_CAST(REGEXP_EXTRACT(description, r'(.[W][D])') as STRING) like '4WD'
			--THEN SAFE_CAST('Four-wheel Drive' as STRING)
			ELSE SAFE_CAST(REGEXP_EXTRACT(description, r'[|] \w+.\S+,.(\w+.\S+ Drive)') as STRING)
		END as drive,
		SAFE_CAST(split(description, ',')[6] as STRING) as color,
		CASE 
			WHEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'1-owner vehicle: (\S{3})') AS STRING) is not Null
			THEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'1-owner vehicle: (\S{3})') AS STRING)
			ELSE "No"
		END as one_owner,
		CASE 
			WHEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'Accidents or damage: (\S* \S+) [|]') AS STRING) is not Null
			THEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'Accidents or damage: (\S* \S+) [|]') AS STRING)
			WHEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'Accidents or damage: (\S* \S+) [|]') AS STRING) is Null
			THEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'Accidents or damage: (\S* \S+ \S+ \S+ \S+ \S+ \S+) [|]') AS STRING)
			ELSE null
		END as accidents_or_damage,
		CASE 
			WHEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'Clean title: (\S{3}) [|]') AS STRING) is not Null
			THEN SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r'Clean title: (\S{3}) [|]') AS STRING)
			ELSE "No"
		END as clean_title,
		SAFE_CAST(REGEXP_EXTRACT(vehicle_history, r' Personal use only: (\S+)') AS STRING) as personal_use_only,
		SAFE_CAST(comment AS STRING) AS comment,
		SAFE_CAST(scrap_date as TIMESTAMP) as scrap_date, 
		SAFE_CAST(source_id as STRING) as source_id, 
		SAFE_CAST(dl_loaded_date as TIMESTAMP) as modified_date
		FROM `paid-project-346208`.car_ads_ds_landing.`cars_com_card_direct_300_Dima`;
	CALL `paid-project-346208`.meta_ds.usp_write_log_Maksym(task_id, "cars_com_card_tokenized_300_Dima_first_version", 'Succeed', inserted_task_id);

END;