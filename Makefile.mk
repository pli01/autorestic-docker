EDITOR=vim
SHELL = /bin/bash
UNAME = $(shell uname -s)

ifeq ($(UNAME),Linux)
include /etc/os-release
endif
ID_U = $(shell id -un)
ID_G = $(shell id -gn)
# enable trace in shell
DEBUG ?= 
#
# Tricks to uppper case
#
UC = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')
#
# docker-compose options
#
DOCKER_USE_TTY := $(shell test -t 1 && echo "-t" )
DC_USE_TTY     := $(shell test -t 1 || echo "-T" )

# global docker prefix
DC_AUTORESTIC_DEFAULT_CONF ?= docker-compose.yml
DC_AUTORESTIC_CUSTOM_CONF ?= docker-compose-custom.yml

DC_AUTORESTIC_BUILD_CONF ?= -f docker-compose-build.yml
DC_AUTORESTIC_RUN_CONF ?= -f ${DC_AUTORESTIC_DEFAULT_CONF}
# detect custom docker-compose file
ifneq ("$(wildcard ${DC_AUTORESTIC_CUSTOM_CONF})","")
DC_AUTORESTIC_RUN_CONF += -f ${DC_AUTORESTIC_CUSTOM_CONF}
endif

# Default registry
DOCKER_REGISTRY   := ghcr.io
DOCKER_REPOSITORY := pli01/autorestic-docker
#
# autorestic
#
AUTORESTIC_VERSION ?= v1.2.0
