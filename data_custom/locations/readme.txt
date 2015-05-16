WorldGazetteer.csv - Primary source of locations, and lat/long is in here for some of them
------------------

http://world-gazetteer.com/

Converted to true CSV (not TSV)
Removed localised place names
Removed IDs column
Removed HTML entities in place types
Added header column
Removed aggregations

CivicSpace-zipcodes.csv - Used for lat/long of USA cities
-----------------------

http://www.boutell.com/zipcodes/

Note that this database cannot be used as a database of cities. For any zip code, it will tell you one location for that zip code. However, a zip code may be shared. E.g. 55025 is for Columbus MN and Forest Lake MN, only Forest Lake is in the spreadsheet.

(currently mostly unused by Composr code - but useful in algorithms for relating postcodes to counties, and finding distances, etc)

World_Cities_Location_table.csv - Used for lat/long of cities
-------------------------------

http://askbahar.com/2010/07/02/world-city-locations-database/

Converted to true CSV (not TSV)
Removed IDs column
Removed altitude column
Added header column

worldcitiespop.csv - Used for lat/long of cities (fallback)
------------------

http://www.maxmind.com/app/worldcities

This is a huge database, so we just use it for latitude/longitude lookups of WorldGazetteer.csv cities.

Yahoo/Google/Bing/etc - Used for lat/long of cities (fallback)
---------------------

[Web service]

uk_postcode_db.csv - UNUSED
------------------

http://www.dangibbs.co.uk/journal/free-uk-postcode-towns-counties-database

(currently unused by Composr code - but useful in algorithms for relating postcodes to counties, and finding distances, etc)

Geonames - UNUSED
--------

http://download.geonames.org/export/dump/

(This is just a note of the presence of this database - but we do not use it at all as it is too big)
