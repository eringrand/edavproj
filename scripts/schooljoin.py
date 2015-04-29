#!/bin/bash/env python3.3

"""
Simple script to join clustering data with GeoJSON 
"""

import json
import csv

# original schools
with open('../../json/nynta.json', 'r') as f:
    schools = json.loads(f.read())

# Importing all info
with open('', 'r')  as f:
    # table of school info keyed on school dbn
    schooljoin = {}
    reader = csv.DictReader(f)

    for row in reader:
        dbn = row['dbn']
        del row['dbn']
        schooljoin[dbn] = row

# update schools json with hannah's new properties
remove = set()
for i, feature in enumerate(schools['features']):
    properties = feature['properties']
    dbn = properties['ATS_CODE'].strip()
    if dbn in schoolprops:
        properties.update(schoolprops[dbn])
    else:
        remove.add(i)

assert len(schoolprops) == len(schools['features']) - len(remove)

# create a copy that only schools in hannah's info set
schools_trim = dict(schools)
schools_trim['features'] = [f for i, f in enumerate(schools['features']) if i not in remove]

assert len(schools_trim['features']) == len(schoolprops)

# sanity check
for feature in schools_trim['features']:
    properties = feature['properties']
    assert 'GRADE' in properties
    assert 'CLUSTER' in properties

# output files
with open('schools_with_info.json', 'w') as f:
    json.dump(schools, f)

with open('schools_with_info_trim.json', 'w') as f:
    json.dump(schools_trim, f)
