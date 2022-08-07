sudo apt update && sudo apt upgrade -yq

# Install Python v3.6
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.6
python3.6 -m pip install pipenv

# Install PostgreSQL v10.20

# Install PostGIS v3.2.0

# Install Django
python3.6 -m pipenv install Django

# Install GDAL 
sudo apt install -y gdal-bin libgdal-dev
sudo apt install -y python3-gdal

# Install GEOS
sud apt install -y binutils libproj-dev
sud apt install -y libgeos++

# Install PROJ.4
sudo apt install -y proj-bin

# 


