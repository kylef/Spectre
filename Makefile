MODULESDIR = .conche/modules
LIBDIR = .conche/lib
SWIFTFLAGS = -I $(MODULESDIR) -L $(LIBDIR)
SWIFT := swift
SWIFTC := swiftc
SOURCES := Assert Context GlobalContext Case Failure Reporter
SOURCE_FILES = $(foreach file,$(SOURCES),Spectre/$(file).swift)

all: $(LIBDIR)/libSpectre.dylib

$(LIBDIR)/libSpectre.dylib: $(SOURCE_FILES)
	@echo "Building Spectre"
	@mkdir -p $(MODULESDIR) $(LIBDIR)
	@$(SWIFTC) $(SWIFTFLAGS) -module-name Spectre -emit-module -emit-library -emit-module-path $(MODULESDIR)/Spectre.swiftmodule -o $(LIBDIR)/libSpectre.dylib Spectre/*.swift

example: $(LIBDIR)/libSpectre.dylib
	@echo "Building Example"
	@$(SWIFT) $(SWIFTFLAGS) -lSpectre Example.swift

clean:
	@rm -fr .conche
