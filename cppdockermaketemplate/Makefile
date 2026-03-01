# Compiler and flags
CXX := g++
CPPFLAGS := -Iinc
CXXFLAGS := -std=c++2a -Wall -Wextra -g
LDFLAGS :=
LDLIBS :=
TEST_LDLIBS := -lgtest -lgtest_main -pthread

MKDIR := mkdir -p
RMDIR := rm -rf

INC_DIR := inc
SRC_DIR := src
TEST_DIR := test/src
BUILD_DIR := ../build
OBJ_DIR := $(BUILD_DIR)/obj
TEST_OBJ_DIR := $(BUILD_DIR)/test_obj
DEP_DIR := $(BUILD_DIR)/dep
SRC_DEP_DIR := $(DEP_DIR)/src
TEST_DEP_DIR := $(DEP_DIR)/test
BIN_DIR := ../bin
TARGET := debugBin
TEST_TARGET := testBin

SRC_EXT := cpp
SOURCES := $(wildcard $(SRC_DIR)/*.$(SRC_EXT))
OBJECTS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SOURCES:.$(SRC_EXT)=.o))
DEPS := $(patsubst $(SRC_DIR)/%,$(SRC_DEP_DIR)/%,$(SOURCES:.$(SRC_EXT)=.d))

TEST_SOURCES := $(wildcard $(TEST_DIR)/*.$(SRC_EXT))
TEST_OBJECTS := $(patsubst $(TEST_DIR)/%,$(TEST_OBJ_DIR)/%,$(TEST_SOURCES:.$(SRC_EXT)=.o))
TEST_DEPS := $(patsubst $(TEST_DIR)/%,$(TEST_DEP_DIR)/%,$(TEST_SOURCES:.$(SRC_EXT)=.d))

.PHONY: all build test run clean sonar

all: build test

build: $(TARGET)

test: $(TEST_TARGET)
	@./$(BIN_DIR)/$(TEST_TARGET)

run: $(TARGET)
	@./$(BIN_DIR)/$(TARGET)

clean:
	@$(RMDIR) $(BUILD_DIR) $(BIN_DIR)

sonar: clean
	@bear --output ../compile_commands.json --append -- $(MAKE) build

$(TARGET): $(OBJECTS)
	@$(MKDIR) $(BIN_DIR)
	@$(CXX) $^ $(LDFLAGS) $(LDLIBS) -o $(BIN_DIR)/$(TARGET)

$(TEST_TARGET): $(filter-out $(OBJ_DIR)/main.o, $(OBJECTS)) $(TEST_OBJECTS)
	@$(MKDIR) $(BIN_DIR)
	@$(CXX) $^ $(LDFLAGS) $(TEST_LDLIBS) -o $(BIN_DIR)/$(TEST_TARGET)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.$(SRC_EXT)
	@$(MKDIR) $(dir $@) $(dir $(SRC_DEP_DIR)/$*)
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(SRC_DEP_DIR)/$*.d -c -o $@ $<

$(TEST_OBJ_DIR)/%.o: $(TEST_DIR)/%.$(SRC_EXT)
	@$(MKDIR) $(dir $@) $(dir $(TEST_DEP_DIR)/$*)
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -MF $(TEST_DEP_DIR)/$*.d -c -o $@ $<

-include $(DEPS) $(TEST_DEPS)
