all: mk.mrvaserver

mrvaserver.tmp:
	rm -fR mrvaserver.tmp
	cp -r  ../../../mrvaserver mrvaserver.tmp

MSER_TARGET := mrva-server:0.1.24
mser: mk.mrvaserver
mk.mrvaserver: mrvaserver.tmp
	docker build -t ${MSER_TARGET} .
	touch $@

mserserve: mser
	docker run --env-file ../../.env.container --rm -it ${MSER_TARGET} /bin/bash

clean:
	-docker rmi -f ${MSER_TARGET}
	-rm mrvaserver

mser-push: mk.mser-push
mk.mser-push: mk.mrvaserver
	docker tag ${MSER_TARGET} ghcr.io/hohn/${MSER_TARGET}
	docker push ghcr.io/hohn/${MSER_TARGET}
	touch $@

mser-test:
	docker pull ghcr.io/hohn/${MSER_TARGET}
	docker run --rm -it --name test-mrva-server-codeql ghcr.io/hohn/${MSER_TARGET} sh

