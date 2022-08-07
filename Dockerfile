FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -yq

# Install PostgreSQL (with PostGIS)
RUN apt install -y gnupg software-properties-common
RUN apt install -y wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -y install postgresql-13 postgis postgresql-13-postgis-3

# Change PostgreSQL Password
RUN echo "postgres\npostgres" | passwd postgres

# Start PostgreSQL
RUN service postgresql start
# RUN pg_ctlcluster 13 main start  # start by user 'postgres'

# Install QGIS (with GDAL, GEOS, and PROJ.4)
RUN wget -qO - https://qgis.org/downloads/qgis-2021.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import
RUN chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg
RUN add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main"
RUN apt update
RUN apt install -y qgis qgis-plugin-grass
RUN apt install -y gdal-bin libgdal-dev

# Install Python v3.6
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update
RUN apt install -y python3.6 python3-pip

# Alter postgres password
# RUN su postgres -c "pg_ctlcluster 13 main start"
RUN service postgresql start && echo "ALTER USER postgres WITH PASSWORD 'postgres';" | su postgres -c psql

# Install Python Dependencies
COPY ./requirements.txt /code/requirements.txt
RUN pip3 install -r /code/requirements.txt

# Run The Application
EXPOSE 8000:8000
COPY . /code
WORKDIR /code
RUN python3 manage.py test
RUN python3 manage.py makemigrations

# ENTRYPOINT [ "/usr/bin/bash", "-c", "service postgresql start && python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000"]
# ======================================

# FROM python:3.6-alpine

# RUN apk add postgis
# RUN apk add binutils gdal py3-gdal

# # Install Python Requirements
# RUN pip install Django 
# RUN pip install psycopg2-binary

# ENTRYPOINT [ "/bin/bash" ]
