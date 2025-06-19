VERSION=1.11.14

DOCKER_IMAGE_TAG=jsonguard/vless-mikrotik:${VERSION}-singbox
DOCKER_IMAGE_PLATFORM=arm,arm64
DOCKER_BUILD_CONTEXT=.

version:
	echo "Version is: ${VERSION}"

build: version
	docker build ${DOCKER_BUILD_CONTEXT} -t ${DOCKER_IMAGE_TAG} --platform ${DOCKER_IMAGE_PLATFORM} --build-arg SING_BOX_VERSION=${VERSION}

push: version
	docker push ${DOCKER_IMAGE_TAG}
