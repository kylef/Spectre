MODULESDIR = .conche/modules
LIBDIR = .conche/lib
SWIFTFLAGS = -I $(MODULESDIR) -L $(LIBDIR)
SWIFTC := swiftc
SOURCES := Assert Context GlobalContext Case Failure Reporter Reporters
SOURCE_FILES = $(foreach file,$(SOURCES),Spectre/$(file).swift)

all: $(LIBDIR)/libSpectre.dylib

$(LIBDIR)/libSpectre.dylib: $(SOURCE_FILES)
	@echo "Building Spectre"
	@mkdir -p $(MODULESDIR) $(LIBDIR)
	@$(SWIFTC) $(SWIFTFLAGS) -module-name Spectre -emit-module -emit-library -emit-module-path $(MODULESDIR)/Spectre.swiftmodule -o $(LIBDIR)/libSpectre.dylib Spectre/*.swift

example: $(LIBDIR)/libSpectre.dylib
	@echo "Building Example"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Example -o example Example.swift

test-example: example
	@./example

clean:
	@rm -fr .conche example
