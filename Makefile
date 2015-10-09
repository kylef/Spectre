MODULESDIR = .conche/modules
LIBSDIR = .conche/libs
SWIFTFLAGS = -I $(MODULESDIR) -L $(LIBSDIR)

libSpectre:
	@echo "Building Spectre"
	@swiftc $(SWIFTFLAGS) -module-name Spectre -emit-module -emit-library -emit-module-path $(MODULESDIR)/Spectre.swiftmodule -o $(LIBSDIR)/libSpectre.dylib Spectre/*.swift

example: libSpectre
	@echo "Building Example"
	@swift $(SWIFTFLAGS) -lSpectre Example.swift

