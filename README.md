# content_balanced_grid
Content balanced grid code splits the map based on content not on size. 

For a exaample of usage look at page 18-23 at http://www.slideshare.net/laopsahl/foss4-g-topologyjuly162015

#Here i short explanation on how we use id 

##First we create a table based cell with a int id. If you don't need the id you can create the table on the fly.

```
create table topo_ar5.cell_ad( id serial, geo geometry(Geometry,4258));
```

##Then we call this function with given parameters and inserts the result into this table.
Parameters 1 : An array of tables names and the name of geometry columns.


