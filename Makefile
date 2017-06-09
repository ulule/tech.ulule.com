build:
	pelican -s pelicanconf.py

rebuild:
	pelican -d -s pelicanconf.py

regenerate:
	pelican -r -s pelicanconf.py

dependencies:
	npm install
	pip install -r requirements.txt

reserve: build serve

watch:
	npm run watch

serve:
	cd output && python -m http.server
