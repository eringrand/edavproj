#!/bin/bash/env python3.3

"""
Joining school clustered SAT data with the schools.json file
"""

import json
import csv

# Loading schools JSON file
with open('../../json/schools.json', 'r') as f:
    schools = json.loads(f.read())

#  Loading all SAT data
with open('all.csv', 'r')  as f:
    # table of school info keyed on school dbn
    schools = {}
    reader = csv.DictReader(f)

    for row in reader:
        dbn = row['DBN']
        del row['DBN']
        schools[dbn] = row

# Update schools JSON with new properties and data
remove = set()
for i, feature in enumerate(schools['features']):
    properties = feature['properties']
    dbn = properties['ATS_CODE'].strip()
    if dbn in schools:
        properties.update(schools[dbn])
    else:
        remove.add(i)

assert len(schoolprops) == len(schools['features']) - len(remove)

# Trim to feature only relevant schools i.e. schools with SAT scores
schools_trim = dict(schools)
schools_trim['features'] = [f for i, f in enumerate(schools['features']) if i not in remove]

assert len(schools_trim['features']) == len(schools)

# sanity check
for feature in schools_trim['features']:
    properties = feature['properties']
    assert 'SAT' in properties

# output files
with open('schools_with_info.json', 'w') as f:
    json.dump(schools, f)

with open('schools_with_info_trim.json', 'w') as f:
    json.dump(schools_trim, f)
