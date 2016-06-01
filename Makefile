BUILDDIR = .build/debug
SWIFTFLAGS = -I $(BUILDDIR) -L $(BUILDDIR)
SWIFTC := swiftc
INTEGRATION = Passing Disabled Failing
INTEGRATION_BINS = $(foreach file,$(INTEGRATION),Tests/Integration/$(file))


all: spectre tests integration Example/example
spectre:
	swim build

integration: $(INTEGRATION_BINS)

Tests/Integration/%: spectre Tests/Integration/%.swift
	@echo "Building $* Integration"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Integration$* -o Tests/Integration/$* Tests/Integration/$*.swift

Example/example: spectre Example/example.swift
	@echo "Building Example"
	@$(SWIFTC) $(SWIFTFLAGS) -lSpectre -module-name Example -o Example/example Example/example.swift

test: tests test-example test-integration
	swim test

test-integration: integration
	@echo "Running Integration"
	@./Tests/Integration/run.sh $(INTEGRATION_BINS)
	@echo

test-example: Example/example
	@echo "Running Example"
	@./Example/example
	@echo

clean:
	@swim clean
	@rm -fr .conche Example/example tests $(INTEGRATION_BINS)
