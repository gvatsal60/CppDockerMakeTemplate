# Include configuration files
include Makefile.config
include Docker.config

# Set default goal
.DEFAULT_GOAL := build

# Help target to display available targets
.PHONY: help
help: ## Display available targets and their descriptions
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Targets
all: build debug  ## Build image and debug the code

build:
	buildImg

# Build Docker image
buildImg:
	@$(DOCKER_HOST) image build -t $(DOCKER_IMG_FULL_NAME) .

# Compile code
debug:
	@$(MKDIR) $(BUILD)
	@$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_IMG_FULL_NAME) $(BUILD_CMD)

# Run code
run:
	@$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_IMG_FULL_NAME) ./$(DEBUG_EXEC)

# Test code
test: debug  ## Run tests

# Clean up generated files
clean:
	$(RMDIR) $(BUILD)/**