all: mk.mrvaagent

mrvaagent.tmp:
	rm -fR mrvaagent.tmp
	cp -r  ../../../mrvaagent mrvaagent.tmp

MAG_TARGET := mrva-agent:0.1.24
mag: mk.mrvaagent
mk.mrvaagent: mrvaagent.tmp
	docker build --no-cache --network host -t ${MAG_TARGET} .
	touch $@

magserve: mag
	docker run --env-file ../../.env.container --rm -it ${MAG_TARGET} /bin/bash

clean:
	-docker rmi -f ${MAG_TARGET}
	-rm mrvaagent

mag-push: mk.mag-push
mk.mag-push: mk.mrvaagent
	docker tag ${MAG_TARGET} ghcr.io/hohn/${MAG_TARGET}
	docker push ghcr.io/hohn/${MAG_TARGET}
	touch $@

mag-test:
	docker pull ghcr.io/hohn/${MAG_TARGET}
	docker run --env-file ../../.env.container \
	--name test-mrva-agent \
	--rm -it ghcr.io/hohn/${MAG_TARGET} \
	sh

