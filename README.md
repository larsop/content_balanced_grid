# content_balanced_grid
Content balanced grid code splits the map based on content not on size. 

For a exaample of usage look at page 18-23 at http://www.slideshare.net/laopsahl/foss4-g-topologyjuly162015

#Here i short explanation on how we use id 

##First we create a table based cell with a int id. If you don't need the id you can create the table on the fly.

```
create table topo_ar5.cell_ad( id serial, geo geometry(Geometry,4258));
```

##Then we call this function and insert the result from func_grid.content_based_balanced_grid save the result into given table.

Parameter 1 : ARRAY['org_ar5.ar5_flate geo']
- An array of tables names and the name of geometry columns.
The table name must contain both schema and table name, The geometry column name must follow with one single space after the table name. In this case work on table org_ar5.ar5_flate

Parameter 2 : 4000
- Max_rows this is the max number rows that intersects with box before it's split into 4 new boxes 
In this case we max 4000 rows bb that touches ecah cell 

```
INSERT INTO func_grid.cell_test(geo) 
SELECT q_grid.cell::geometry(geometry,4258)  as geo 
FROM (
SELECT(ST_Dump(
func_grid.content_based_balanced_grid(ARRAY['org_ar5.ar5_flate geo'],4000))
).geom AS cell) AS q_grid;

```

