# Compiler and flags
CXX := g++
CXXFLAGS := -std=c++14 -Wall -Wextra
LDFLAGS := -pthread

# Directories
SRCDIR := src
TESTDIR := test
BUILDDIR := build
BINDIR := bin

# Files
SRC := $(wildcard $(SRCDIR)/*.cpp)
TESTSRC := $(wildcard $(TESTDIR)/*.cpp)
OBJ := $(patsubst $(SRCDIR)/%.cpp,$(BUILDDIR)/%.o,$(SRC))
TESTOBJ := $(patsubst $(TESTDIR)/%.cpp,$(BUILDDIR)/%.o,$(TESTSRC))
DEP := $(OBJ:.o=.d)
TESTDEP := $(TESTOBJ:.o=.d)
EXEC := $(BINDIR)/test_executable

# Targets
.PHONY: all clean

all: build test run

build: $(EXEC)

test: $(EXEC)
	@$(EXEC)

run: $(EXEC)
	@./$(EXEC)

clean:
	$(RM) -r $(BUILDDIR) $(BINDIR)

# Compile rules
$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -MMD -MP -c $< -o $@

$(BUILDDIR)/%.o: $(TESTDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -I$(SRCDIR) -I$(TESTDIR) -MMD -MP -c $< -o $@

# Link rule
$(EXEC): $(OBJ) $(TESTOBJ)
	@mkdir -p $(@D)
	$(CXX) $(LDFLAGS) $^ -o $@

-include $(DEP) $(TESTDEP)
