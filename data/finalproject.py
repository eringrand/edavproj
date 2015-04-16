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

