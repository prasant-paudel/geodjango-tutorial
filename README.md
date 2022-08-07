# GeoDjango Tutorial - RealPython

## Install PostgreSQL (includes PostGIS)
```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql-13
sudo apt-get -y install postgis postgresql-13-postgis-3
```
Change password for postgres
```
PASSWORD=postgres
echo -e "$PASSWORD\n$PASSWORD" | sudo passwd postgres
```
Start PostgreSQL
```
sudo service postgresql start
# OR
sudo su postgres -c "pg_ctlcluster 13 main start"
```

## Install QGIS (includes GDAL, GEOS, PROJ.4)
```bash
sudo apt install wget gnupg software-properties-common
```
```bash
wget -qO - https://qgis.org/downloads/qgis-2021.gpg.key | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import
sudo chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg
```
```bash
sudo add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main"
sudo apt update
sudo apt install -y qgis qgis-plugin-grass
sudo apt install -y gdal-bin libgdal-dev
```

## Install Python 3.6
```bash
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.6
sudo python3.6 -m ensurepip
```

## Install Django (includes GeoDjango)
python3.6 -m pip install Django

## Add GeoDjango to the Project
```python
INSTALLED_APPS = [
    # [...]
    'django.contrib.gis'
]
```

## Create an App
```python
python3 manage.py startapp shops
```
```python
INSTALLED_APPS = [
    # [...]
    'django.contrib.gis',
    'shops'
]
```

## Create Django Models
`shops/models.py`
```python
from django.contrib.gis.db import models

class Shop(models.Model):
    name = models.CharField(max_length=100)
    location = models.PointField()
    address = models.CharField(max_length=100)
    city = models.CharField(max_length=50)
```
`PointField` is a GeoDjango-specific geometric field for sorting GEOS Point object that represents a pair of longitude and latitude coordinates.

## Register Django Models in the Admin Interface
`shops/admin.py`
```python
from django.contrib.gis import admin
from .models import Shop

@admin.register(Shop)
class ShopAdmin(admin.OSMGeoAdmin):
    list_display = ('name', 'location')
```

## Create Database Tables
```
python3 manage.py makemigrations
pytho3 manage.py migrate
```

## Leaflet JS