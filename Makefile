# SPDX-FileCopyrightText: 2021 Xiaodong Xu <xuxiaodong@pm.me>
#
# SPDX-License-Identifier: MIT

IMG = debcross
REPO = $(USER)/$(IMG)

ifeq ($(ARCH),amd64)
MICROARCH = x86_64
SUFFIX = gnu
else ifeq ($(ARCH),i386)
MICROARCH = i386
SUFFIX = gnu
else ifeq ($(ARCH),arm64)
MICROARCH = aarch64
SUFFIX = gnu
else ifeq ($(ARCH),armel)
MICROARCH = arm
SUFFIX = gnueabi
else ifeq ($(ARCH),armhf)
MICROARCH = arm
SUFFIX = gnueabihf
else ifeq ($(ARCH),mips)
MICROARCH = mips
SUFFIX = gnu
else ifeq ($(ARCH),mipsel)
MICROARCH = mipsel
SUFFIX = gnu
else ifeq ($(ARCH),mips64el)
MICROARCH = mips64el
SUFFIX = gnuabi64
else ifeq ($(ARCH),powerpc)
MICROARCH = powerpc
SUFFIX = gnu
else ifeq ($(ARCH),ppc64el)
MICROARCH = powerpc64le
SUFFIX = gnu
else ifeq ($(ARCH),s390x)
MICROARCH = s390x
SUFFIX = gnu
endif

all: build tag push

lint: Dockerfile
	hadolint $<
build:
	docker buildx build \
		--build-arg ARCH="$(ARCH)" \
		--build-arg MICROARCH="$(MICROARCH)" \
		--build-arg SUFFIX="$(SUFFIX)" \
		--tag "$(REPO):$(ARCH)" \
		.

tag:
	docker tag $(REPO):$(ARCH) $(REPO):$(ARCH)-$(shell date -u +%Y%m%d)

push: tag
	docker push -a $(REPO)

.PHONY: all
