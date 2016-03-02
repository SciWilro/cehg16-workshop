#!/usr/bin/python
#this script can be used to get lat/lon of a given addess/locaion using google API
import sys,json,urllib
base="http://maps.googleapis.com/maps/api/geocode/json?address="
if len(sys.argv)!=2:
	adr=raw_input('Enter the address/location of interest:\n').split(" ")
else:
	adr=sys.argv[1].split(" ")

adr='+'.join(adr)
q=base+adr

url = urllib.urlopen(q).read()
result = json.loads(url)
out=result['results'][0]['geometry']['location']
v=str(out['lat'])+","+str(out['lng'])
print v
