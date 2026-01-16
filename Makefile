CC=gcc
CXX=g++
LD=lld

INCLUDE_DIR=./include
SOURCE_DIR=./src
TESTSOURCE_DIR=./testsrc
OBJDIR=./obj
TESTOBJDIR=./testobj
TESTBINDIR=./testbin
COVERAGEDIR=./htmlcov

INCLUDE  += -I $(INCLUDE_DIR)
DEFINES  +=
CFLAGS   += -Wall -Werror -Wpedantic
CXXFLAGS += $(CFLAGS)
LDFLAGS  += -fuse-ld=$(LD)

GTEST_CFLAGS := $(shell pkg-config --cflags gtest_main)
GTEST_LDFLAGS  := $(shell pkg-config --libs gtest_main)

TEST_CFLAGS   := -Wall -Werror -Wpedantic -g -O0 --coverage $(GTEST_CFLAGS)
TEST_CXXFLAGS := $(TEST_CFLAGS)
TEST_LDFLAGS  := -fuse-ld=$(LD) -lgcov -lpthread $(GTEST_LDFLAGS)

SOURCES := StringUtils
TESTS := StringUtilsTest

.PHONY: all directories test_directories test clean

all: directories $(OBJDIR)/$(SOURCES).o

test: all test_directories cover

cover: $(TESTBINDIR)/$(TESTS)
	$(TESTBINDIR)/$(TESTS)
	lcov --capture --directory . --output-file $(COVERAGEDIR)/coverage.info --ignore-errors inconsistent,source
	lcov --remove $(COVERAGEDIR)/coverage.info '/usr/*' '*/testsrc/*' --output-file $(COVERAGEDIR)/coverage.info
	genhtml $(COVERAGEDIR)/coverage.info --output-directory $(COVERAGEDIR)

$(OBJDIR)/%.o: $(SOURCE_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(DEFINES) $(INCLUDE) -c $< -o $@

$(TESTOBJDIR)/%.o: $(SOURCE_DIR)/%.cpp
	$(CXX) $(TEST_CXXFLAGS) $(DEFINES) $(INCLUDE) -c $< -o $@

$(TESTOBJDIR)/$(TESTS).o: $(TESTSOURCE_DIR)/$(TESTS).cpp
	$(CXX) $(TEST_CXXFLAGS) $(DEFINES) $(INCLUDE) -c $< -o $@

$(TESTBINDIR)/$(TESTS): $(TESTOBJDIR)/$(TESTS).o $(TESTOBJDIR)/$(SOURCES).o
	$(CXX) $(TEST_LDFLAGS) $(TEST_CXXFLAGS) $(DEFINES) $^ -o $@

directories: $(OBJDIR)

$(OBJDIR):
	mkdir -p $(OBJDIR)

test_directories: $(TESTBINDIR) $(TESTOBJDIR) $(COVERAGEDIR)

$(TESTOBJDIR):
	mkdir -p $(TESTOBJDIR)

$(TESTBINDIR):
	mkdir -p $(TESTBINDIR)

$(COVERAGEDIR):
	mkdir -p $(COVERAGEDIR)

clean:
	rm -rf $(OBJDIR) $(TESTOBJDIR) $(TESTBINDIR) $(COVERAGEDIR)