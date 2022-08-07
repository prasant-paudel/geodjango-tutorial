docker build . -t geodjango:latest 
docker run --rm --name geodjango -v "`pwd`":/code -p 8000:8000 -it geodjango:latest bash
