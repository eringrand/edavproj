import pandas as pd


pd.options.display.max_columns = 5200
pd.options.display.max_rows    = 5200

# Setting workspace
wk = "/edavproject/ny_shapefile" 

# Downloading the Shapefile
import urllib

zipLoc = wk+"nynta_15a.zip"
fileURL = "http://www.nyc.gov/html/dcp/download/bytes/nynta_15a.zip"
urllib.urlretrieve (fileURL, zipLoc)  

# Unzipping 
import zipfile  
  
zip = zipfile.ZipFile(zipLoc)  
zip.extractall(wk) 

ogr2ogr -f GeoJSON /edavproject/ny_shapefile/nyc.json /edavproject/ny_shapefile/nynta.shp

topojson /edavproject/nyc.topo.json /edavproject/ny_shapefile/nyc.json

# Reading our cleaned data in
data = pd.read_csv(data, header=11) 


data.head(3) #Let's see the data


#Census API
# Code for using the Census API to download US Census and American Community Survey Data


# Here are some sample for population url's for Census Tract

###Census 2000 sf1
#####Example Pop for State: 36, County: 1, Tract: 100
######1728
	http://api.census.gov/data/2000/sf1?key=30699f15ab4d04a1e0943715b539d256c9a3ee44&get=P001001&for=tract:*&in=state:36

###Census 2000 sf3
#####Example Pop for State: 36, County: 1, Tract: 100
######1739
	http://api.census.gov/data/2000/sf3?key=30699f15ab4d04a1e0943715b539d256c9a3ee44&get=P001001&for=tract:*&in=state:36
###Census 2010 sf1
#####Example Pop for State: 36, County: 1, Tract: 100
######2139
	http://api.census.gov/data/2010/sf1?key=30699f15ab4d04a1e0943715b539d256c9a3ee44&get=P0010001&for=tract:*&in=state:36
###American Community Survey 2008-2012 acs5
#####Example Pop for State: 36, County: 1, Tract: 100
######2235
	http://api.census.gov/data/2012/acs5?key=30699f15ab4d04a1e0943715b539d256c9a3ee44&get=B01003_001E&for=tract:*&in=state:36