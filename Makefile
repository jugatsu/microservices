BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
GIT_HASH = $(shell git show --format="%h" HEAD | head -1)
VERSION ?= latest

.PHONY: all comment post ui prom alert blackbox mongodb-exporter push

all: comment post ui prom alert blackbox mongodb-exporter

comment:
	echo $(GIT_HASH) > src/comment/build_info.txt
	echo $(BRANCH) >> src/comment/build_info.txt
	docker build --build-arg VCS_REF=$(GIT_HASH) \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/comment:$(GIT_HASH) src/comment
	docker tag $(USER_NAME)/comment:$(GIT_HASH) $(USER_NAME)/comment:$(VERSION)

post:
	echo $(GIT_HASH) > src/post-py/build_info.txt
	echo $(BRANCH) >> src/post-py/build_info.txt
	docker build --build-arg VCS_REF=$(GIT_HASH) \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/post:$(GIT_HASH) src/post-py
	docker tag $(USER_NAME)/post:$(GIT_HASH) $(USER_NAME)/post:$(VERSION)

ui:
	echo $(GIT_HASH) > src/ui/build_info.txt
	echo $(BRANCH) >> src/ui/build_info.txt
	docker build --build-arg VCS_REF=$(GIT_HASH) \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/ui:$(GIT_HASH) src/ui
	docker tag $(USER_NAME)/ui:$(GIT_HASH) $(USER_NAME)/ui:$(VERSION)

prom:
	docker build --build-arg VCS_REF=$(GIT_HASH) \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/prometheus:$(GIT_HASH) monitoring/prometheus/config
	docker tag $(USER_NAME)/prometheus:$(GIT_HASH) $(USER_NAME)/prometheus:$(VERSION)

alert:
	docker build --build-arg VCS_REF=$(GIT_HASH) \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/alertmanager:$(GIT_HASH) monitoring/prometheus/alertmanager
	docker tag $(USER_NAME)/alertmanager:$(GIT_HASH) $(USER_NAME)/alertmanager:$(VERSION)

blackbox:
	docker build --build-arg VCS_REF=$(GIT_HASH) \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/blackbox-exporter:$(GIT_HASH) monitoring/prometheus/blackbox-exporter
	docker tag $(USER_NAME)/blackbox-exporter:$(GIT_HASH) $(USER_NAME)/blackbox-exporter:$(VERSION)

mongodb-exporter:
	docker build --build-arg VCS_REF=$(GIT_HASH) \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/mongodb-exporter:$(GIT_HASH) monitoring/prometheus/mongodb-exporter
	docker tag $(USER_NAME)/mongodb-exporter:$(GIT_HASH) $(USER_NAME)/mongodb-exporter:$(VERSION)

push:
	docker push $(USER_NAME)/comment:$(VERSION)
	docker push $(USER_NAME)/comment:$(GIT_HASH)
	docker push $(USER_NAME)/post:$(VERSION)
	docker push $(USER_NAME)/post:$(GIT_HASH)
	docker push $(USER_NAME)/ui:$(VERSION)
	docker push $(USER_NAME)/ui:$(GIT_HASH)
	docker push $(USER_NAME)/prometheus:$(VERSION)
	docker push $(USER_NAME)/prometheus:$(GIT_HASH)
	docker push $(USER_NAME)/alertmanager:$(VERSION)
	docker push $(USER_NAME)/alertmanager:$(GIT_HASH)
	docker push $(USER_NAME)/blackbox-exporter:$(VERSION)
	docker push $(USER_NAME)/blackbox-exporter:$(GIT_HASH)
	docker push $(USER_NAME)/mongodb-exporter:$(VERSION)
	docker push $(USER_NAME)/mongodb-exporter:$(GIT_HASH)
