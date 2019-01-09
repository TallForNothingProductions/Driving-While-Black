import json
import csv
from shapely.geometry import Point
from shapely.geometry.polygon import Polygon

class DataPoints:
	def __init__(self, lng, lat, pop, white, african_american):
		self.lng = lng
		self.lat = lat
		self.population = pop
		self.white = white
		self.african_american = african_american
		self.point = Point(lng, lat)

class District:
	def __init__(self, name):
		self.name = name
		self.coords = []
		self.groups = []
		self.polygon = None


data = None
district_data = None

locations = []
district_list = []

with open("blocks.json","r") as json_to_read:
	data = json.load(json_to_read)

with open("cmpd.json","r") as json_to_read:
	district_data = json.load(json_to_read)

for block in data['features']:
	census_block_group = DataPoints(
		block['properties']['Longitude'],
		block['properties']['Latitude'],
		block['properties']['Population'], 
		block['properties']['White'],
		block['properties']['African_American']
	)
	locations.append(census_block_group)
	
for district in district_data['features']:
	try:
		new_district = District(district['properties']['DNAME'])
		for polygon_point in district['geometry']['coordinates'][0]:
			new_district.coords.append((polygon_point[0], polygon_point[1]))
		new_district.polygon = Polygon(new_district.coords)
		district_list.append(new_district)
	except:
		print district['properties']['DNAME']
		pass

for district in district_list:
	for location in locations:
		if district.polygon.contains(location.point):
			district.groups.append(location)

with open("district_demographics.csv","w") as file_to_write:
	csv_to_write = csv.writer(file_to_write)
	csv_to_write.writerow(['Name of District','Population','Number of White People','Number of Black People'])
	for row in district_list:
		population = 0
		white = 0
		african_american = 0
		for group in row.groups:
			population += group.population
			white += group.white
			african_american += group.african_american
		csv_to_write.writerow([row.name, population, white, african_american])

print "Finished"




