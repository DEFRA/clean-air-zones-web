build:
	docker build -t pa11y-ci .

test:
	docker run -it -v /vagrant/pa11y/screenshots:/screenshots -e BASE_URL=http://vccs-web-dev-1715195167.eu-west-2.elb.amazonaws.com pa11y-ci
https://dev-fleet.paycleanairzonecharge.co.uk/