##
# Makefile sample
# @see: https://pypi.org/project/pipenv-to-requirements/
#

usage:
	@echo "Usage: make 'target'  where target: app | kafka | all"


####################################################################
# virtual env
####################################################################

.PHONY: pip.setup pip.install pip.upgrade pip.lock


pip.setup:
	python3 -m pip install --upgrade pip --user
	python3 -m pip install --upgrade pipenv --user

pip.install:
	pipenv install --dev

pip.upgrade:
	pipenv upgrade --dev

pip.lock:
	pipenv lock -r  >requirements.txt
	pipenv lock --dev -r  >requirements-dev.txt


####################################################################
# app image
####################################################################


app.image.build:
	docker build -t dk-nosql-labs:5000/app/data-bridge:latest .

app.image.push:
	docker push dk-nosql-labs:5000/app/data-bridge:latest

app.image: app.image.build app.image.push

app: app.image

####################################################################
# kafks image
####################################################################


kafka.image.build:
	docker pull wurstmeister/zookeeper:latest
	docker pull wurstmeister/kafka:latest
	docker tag  wurstmeister/zookeeper:latest dk-nosql-labs:5000/svr/zookeeper:latest
	docker tag  wurstmeister/kafka:latest dk-nosql-labs:5000/svr/kafka:latest

kafka.image.push:
	docker push dk-nosql-labs:5000/svr/zookeeper:latest
	docker push dk-nosql-labs:5000/svr/kafka:latest

kafka.image: kafka.image.build, kafka.image.push


kafka: kafka.image

####################################################################
# all targets
####################################################################

all: kafka app
	
