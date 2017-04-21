
# Define default variables
STATIC_PATH       ?= ./pyaiot/dashboard/static/
BROKER_PORT       ?= 80
BROKER_HOST       ?= riot-demo.inria.fr
DASHBOARD_PORT    ?= 8080
DASHBOARD_TITLE   ?= "Local RIOT Demo Dashboard"
DASHBOARD_LOGO    ?= /static/assets/logo-riot.png
DASHBOARD_FAVICON ?= /static/assets/favicon192.png
CAMERA_URL ?= http://riot-demo.inria.fr/demo-cam/?action=stream

# Targets
deploy: install-dev setup-services

install-dev:
	sudo apt-get install python3-pip libyaml-dev npm -y
	sudo pip3 install .
	make setup-dashboard-npm

setup-services: setup-broker-service setup-dashboard-service

setup-broker-service:
	sudo cp systemd/aiot-broker.service /lib/systemd/system/.
	sudo systemctl enable aiot-broker.service
	sudo systemctl daemon-reload
	sudo systemctl restart aiot-broker.service

setup-dashboard-npm:
	cd pyaiot/dashboard/static && npm install

setup-dashboard-service:
	sudo cp systemd/aiot-dashboard.service /lib/systemd/system/.
	sudo systemctl enable aiot-dashboard.service
	sudo systemctl daemon-reload
	sudo systemctl restart aiot-dashboard.service

run-broker:
	aiot-broker --port=${BROKER_PORT} --debug

run-dashboard:
	aiot-dashboard --static-path=${STATIC_PATH}                         \
		--port=${DASHBOARD_PORT}                                  \
		--broker-port=${BROKER_PORT} --broker-host=${BROKER_HOST} \
		--camera-url=${CAMERA_URL} --title=${DASHBOARD_TITLE}     \
		--logo=${DASHBOARD_LOGO} --favicon=${DASHBOARD_FAVICON}   \
		--debug
