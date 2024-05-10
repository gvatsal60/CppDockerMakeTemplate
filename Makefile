include Makefile.config

# Targets
all: buildImg debug

# To build image
buildImg:
	@$(DOCKER_HOST) image build -t $(DOCKER_IMG_FULL_NAME) .

# Code Compilation
debug:
	@$(MKDIR) $(BUILD)
	@$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_IMG_FULL_NAME) $(BUILD_CMD)

# Code Run
run:
	@$(DOCKER_HOST) container run $(DOCKER_ARG) $(DOCKER_IMG_FULL_NAME) ./$(DEBUG_EXEC)

# Code Test
test: debug

# Code Cleanup
clean:
	$(RMDIR) $(BUILD)/**