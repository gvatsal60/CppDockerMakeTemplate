# Include configuration files
include Docker.mk

BUILD_CMD := $(MAKE) build
TEST_CMD := $(MAKE) test
RUN_CMD := $(MAKE) run
CLEAN_CMD := $(MAKE) clean

DOCKER_FILE_PATH := Dockerfiles/Dockerfile.alpine

# Set default goal
.DEFAULT_GOAL := build

# Help target to display available targets
.PHONY: help
help: ## Display available targets and their descriptions
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Targets
all: build run

# Code Build
build:
	$(DOCKER_HOST) image build -t $(DOCKER_IMG_FULL_NAME) -f $(DOCKER_FILE_PATH) .
	$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_VOL) $(DOCKER_WORK_DIR) $(DOCKER_IMG_FULL_NAME) $(BUILD_CMD)

# Test code
test:
	$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_VOL) $(DOCKER_WORK_DIR) $(DOCKER_IMG_FULL_NAME) $(TEST_CMD)

# Run code
run: build
	$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_VOL) $(DOCKER_WORK_DIR) $(DOCKER_IMG_FULL_NAME) $(RUN_CMD)

# Clean
clean:
	$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_VOL) $(DOCKER_WORK_DIR) $(DOCKER_IMG_FULL_NAME) $(CLEAN_CMD)

.PHONY: clean test