MODULESDIR = .conche/modules
LIBDIR = .conche/lib
SWIFTFLAGS = -I $(MODULESDIR) -L $(LIBDIR)
SWIFTC := swiftc
SOURCES := Assert Context GlobalContext Case Failure Reporter Reporters Global
SOURCE_FILES = $(foreach file,$(SOURCES),Spectre/$(file).swift)
TEST_SOURCES := AssertSpec
TEST_SOURCE_FILES = $(foreach file,$(TEST_SOURCES),SpectreTests/$(file).swift)
INTEGRATION = Passing Failing
INTEGRATION_BINS = $(foreach file,$(INTEGRATION),SpectreTests/Integration/$(file))

all: spectre tests integration example
spectre: $(LIBDIR)/libSpectre.dylib
integration: $(INTEGRATION_BINS)

$(LIBDIR)/libSpectre.dylib: $(SOURCE_FILES)
	@echo "Building Spectre"
	@mkdir -p $(MODULESDIR) $(LIBDIR)
	@$(SWIFTC) $(SWIFTFLAGS) -module-name Spectre -emit-module -emit-library -emit-module-path $(MODULESDIR)/Spectre.swiftmodule -o $(LIBDIR)/libSpectre.dylib Spectre/*.swift

SpectreTests/Integration/%: spectre SpectreTests/Integration/%.swift
	@echo "Building $* Integration"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Integration$* -o SpectreTests/Integration/$* SpectreTests/Integration/$*.swift

tests: spectre $(TEST_SOURCE_FILES)
	@echo "Building Tests"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name SpectreTests -o tests $(TEST_SOURCE_FILES)

example: $(LIBDIR)/libSpectre.dylib Example.swift
	@echo "Building Example"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Example -o example Example.swift

test: tests integration test-example
	@echo "Running Tests"
	@./tests
	@echo

	@echo "Running Integration"
	@./SpectreTests/Integration/run.sh $(INTEGRATION_BINS)

test-example: example
	@echo "Running Example"
	@./example
	@echo


clean:
	@rm -fr .conche example tests $(INTEGRATION_BIN)
