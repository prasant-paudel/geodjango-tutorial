docker build . -t geodjango:latest 
docker run --rm --name geodjango -v .:/code -p 8000:8000 -it geodjango:latest bash
