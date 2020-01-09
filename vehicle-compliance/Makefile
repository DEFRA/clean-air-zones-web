copy-source:
	mkdir -p ~/src
	rsync -av --progress /vagrant/. ~/src --exclude node_modules

vs-code-deps-install:
	gem install ruby-debug-ide
	gem install debase
	
run:
	gem install bundler --version=2.0.2
	mkdir -p ~/src
	rsync -av --progress /vagrant/. ~/src --exclude node_modules
	cd ~/src; bundle install; yarn install; rails s -b 0.0.0.0

unit-test:
	yarn install
	rspec -f d
	
scenario-test:
	yarn install
	cucumber

install-sonar-scanner:
	wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip
	unzip -o sonar-scanner-cli-3.2.0.1227-linux.zip
	chmod +x sonar-scanner-3.2.0.1227-linux/bin/sonar-scanner
	
launch-sonarqube:
	docker run -d --name sonarqube -p 9000:9000 sonarqube
	
stop-sonarqube:
	docker stop sonarqube
	
install-sonar-stack: install-sonar-scanner launch-sonarqube
	
sonar-scan:
	sonar-scanner-3.2.0.1227-linux/bin/sonar-scanner -Dsonar.host.url=http://localhost:9000 -Dsonar.user=admin -Dsonar.password=admin 

docker-build:
	docker build -t vehicle-compliance-checker-frontend:latest --build-arg secret_key_base=secret --build-arg aws_region=eu-west-2 -f Dockerfile.build .
	
docker-run:
	docker run -p 3000:3000 --rm -e COMPLIANCE_CHECKER_API_URL="https://jaqu-caz.herokuapp.com" vehicle-compliance-checker-frontend
