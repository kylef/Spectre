MODULESDIR = .conche/modules
LIBDIR = .conche/lib
SWIFTFLAGS = -I $(MODULESDIR) -L $(LIBDIR)
SWIFTC := swiftc
SOURCES := Expectation Context GlobalContext Case Failure Reporter Reporters Global
SOURCE_FILES = $(foreach file,$(SOURCES),Sources/$(file).swift)
TEST_SOURCES := ExpectationSpec FailureSpec
TEST_SOURCE_FILES = $(foreach file,$(TEST_SOURCES),Tests/$(file).swift)
INTEGRATION = Passing Disabled Failing
INTEGRATION_BINS = $(foreach file,$(INTEGRATION),Tests/Integration/$(file))

all: spectre tests integration example
spectre: $(LIBDIR)/libSpectre.dylib
integration: $(INTEGRATION_BINS)

$(LIBDIR)/libSpectre.dylib: $(SOURCE_FILES)
	@echo "Building Spectre"
	@mkdir -p $(MODULESDIR) $(LIBDIR)
	@$(SWIFTC) $(SWIFTFLAGS) -module-name Spectre -emit-module -emit-library -emit-module-path $(MODULESDIR)/Spectre.swiftmodule -o $(LIBDIR)/libSpectre.dylib Sources/*.swift

Tests/Integration/%: spectre Tests/Integration/%.swift
	@echo "Building $* Integration"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Integration$* -o Tests/Integration/$* Tests/Integration/$*.swift

.PHONY: tests
tests: spectre $(TEST_SOURCE_FILES)
	@echo "Building Tests"
	@cat $(TEST_SOURCE_FILES) > tests.swift
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Tests -o run-tests tests.swift

example: $(LIBDIR)/libSpectre.dylib Example.swift
	@echo "Building Example"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Example -o example Example.swift

test: tests test-example test-integration
	@echo "Running Tests"
	@./run-tests
	@echo

test-integration: integration
	@echo "Running Integration"
	@./Tests/Integration/run.sh $(INTEGRATION_BINS)
	@echo

test-example: example
	@echo "Running Example"
	@./example
	@echo


clean:
	@rm -fr .conche example tests $(INTEGRATION_BINS)
