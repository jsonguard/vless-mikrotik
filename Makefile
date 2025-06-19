VERSION=1.11.13-singbox

DOCKER_IMAGE_TAG=jsonguard/vless-mikrotik:${VERSION}
DOCKER_IMAGE_PLATFORM=arm,arm64
DOCKER_BUILD_CONTEXT=.

version:
	echo "Version is: ${VERSION}"

build: version
	docker build ${DOCKER_BUILD_CONTEXT} -t ${DOCKER_IMAGE_TAG} --platform ${DOCKER_IMAGE_PLATFORM}

push: version
	docker push ${DOCKER_IMAGE_TAG}
