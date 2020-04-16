current=`pwd`

lint:
	docker run -it -v "$(current):/go/src/"  supinf/golangci-lint:1.12 run --no-config -D megacheck

sonar:
	cd deployments; docker-compose -f docker-compose.sonar.yml up -d

sonarstop:
	cd deployments; docker-compose -f docker-compose.sonar.yml down

scan:
	curl -XPOST http://localhost:9000/api/projects/create\?project\=Project\&name\=Project-u admin:admin
	echo "$(current)"
	docker run -eSONAR_LOGIN=admin -e SONAR_PASSWORD=admin -e SONAR_HOST_URL=http://sonarqube:9000 \
		--link sonarqube --network deployments_default -it -v "$(curr):/usr/src" sonarsource/sonar-scanner-cli
