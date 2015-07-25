-- create a separate schema where we place this func
CREATE SCHEMA func_grid ;



-- example of how to use
-- select ST_Area(func_grid.get_table_extent(ARRAY['org_esri_union.table_1 geo_1', 'org_esri_union.table_2 geo_2']));
-- select ST_Area(func_grid.get_table_extent(ARRAY['org_ar5.ar5_flate geo']));

  
DROP FUNCTION func_grid.get_table_extent(schema_table_name_column_name_array VARCHAR[]) cascade;

-- Return the bounding box for given list of arrayes with table name and geo column name 
-- The table name must contain both schema and tablename 
-- The geo column name must follow with one single space after the table name.
-- Does not handle tables with different srid

CREATE OR REPLACE FUNCTION func_grid.get_table_extent (schema_table_name_column_name_array VARCHAR[]) RETURNS geometry  AS
$body$
DECLARE
	grid_geom geometry;
	grid_geom_tmp geometry;	
	line VARCHAR;
	line_values VARCHAR[];
	line_schema_table VARCHAR[];
	geo_column_name VARCHAR;
	schema_table_name VARCHAR;
	source_srid int;
	schema_name VARCHAR := 'org_ar5';
	table_name VARCHAR := 'ar5_flate';
	sql VARCHAR;

BEGIN

	
	FOR i IN ARRAY_LOWER(schema_table_name_column_name_array,1)..ARRAY_UPPER(schema_table_name_column_name_array,1) LOOP
		line := schema_table_name_column_name_array[i];
--		raise NOTICE 'line : %', line;

		SELECT string_to_array(line, ' ') INTO line_values; 
		schema_table_name := line_values[1];
		geo_column_name := line_values[2];
		

		select string_to_array(schema_table_name, '.') into line_schema_table;

		schema_name := line_schema_table[1];
		table_name := line_schema_table[2];
		raise NOTICE 'schema_table_name : %, geo_column_name : %', schema_table_name, geo_column_name;

		sql := 'SELECT Find_SRID('''|| 	schema_name || ''', ''' || table_name || ''', ''' || geo_column_name || ''')';
--		raise NOTICE 'execute sql: %',sql;
		EXECUTE sql INTO source_srid ;

		
		sql :=  'SELECT ST_SetSRID(ST_Extent(' || geo_column_name ||'),' || source_srid || ') FROM ' || schema_table_name; 
--    	raise NOTICE 'execute sql: %',sql;
		EXECUTE sql INTO  grid_geom_tmp;
		  
		IF grid_geom IS null THEN
			grid_geom := ST_SetSRID(ST_Extent(grid_geom_tmp), source_srid);
		ELSE
			grid_geom := ST_SetSRID(ST_Extent(ST_Union(grid_geom, grid_geom_tmp)), source_srid);
		END IF;
		
	END LOOP;

	
	RETURN grid_geom;

END;
$body$
LANGUAGE 'plpgsql';


