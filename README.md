
	v_from_date date;
	v_to_date date;

	begin

	v_from_date := TO_DATE('{DIST_YYYY/MM/DD HH24:MI:SS_UTC}', 'YYYY/MM/DD HH24:MI:SS');
	v_to_date := TO_DATE('{DIET_YYYY/MM/DD HH24:MI:SS_UTC}', 'YYYY/MM/DD HH24:MI:SS');

	-- and then use these in where 

	SELECT ID, DEVICE_TYPE, S3_KEY, TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS 	CREATION_DAT
	FROM KASE_DDL.ARCHIVED_LOG 
	WHERE 
    CREATION_DATE >= v_from_date
    AND CREATION_DATE <= v_to_date