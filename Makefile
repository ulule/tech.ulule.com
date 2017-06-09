ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUILD_DIR = $(ROOT_DIR)/themes/ulule/static/build
OUTPUT_DIR = $(ROOT_DIR)/output

release: docker-prebuild docker-build publish

publish:
	aws s3 cp `pwd`/output s3://ulule.engineering/ --recursive --exclude "*.scss" --exclude ".DS_Store" --profile ulule-engineering --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

build:
	pelican -s pelicanconf.py

rebuild:
	pelican -d -s pelicanconf.py

regenerate:
	pelican -r -s pelicanconf.py

dependencies:
	pip install -r requirements.txt

reserve: build serve

watch:
	npm run watch

serve:
	cd output && python -m http.server

docker-build:
	docker build -t engineering-builder .
	docker run --rm -v $(OUTPUT_DIR):/app/output engineering-builder

docker-prebuild:
	docker build -t engineering-prebuilder -f Dockerfile.build .
	mkdir -p $(BUILD_DIR)
	docker run --rm -v $(BUILD_DIR):/app/themes/ulule/static/build engineering-prebuilder
