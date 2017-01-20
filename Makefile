GOFMT_FILES?=$$(find . -name '*.go' | grep -v vendor)
VETARGS?=-all
TEST?=$$(go list ./...)


all: build copy

build:
	go build -o terraform-provider-alicloud

copy:
	cp terraform-provider-alicloud $(shell dirname `which terraform`)

test: fmtcheck errcheck
	TF_ACC= go test -v ./alicloud $(TESTARGS) -run=TestAccAlicloud -timeout=120m -parallel=4

vet:
	@echo "go tool vet $(VETARGS) ."
	@go tool vet $(VETARGS) $$(ls -d */ | grep -v vendor) ; if [ $$? -eq 1 ]; then \
		echo ""; \
		echo "Vet found suspicious constructs. Please check the reported constructs"; \
		echo "and fix them if necessary before submitting the code for review."; \
		exit 1; \
	fi

fmt:
	gofmt -w $(GOFMT_FILES)

fmtcheck:
	@sh -c "'$(CURDIR)/scripts/gofmtcheck.sh'"

errcheck:
	@sh -c "'$(CURDIR)/scripts/errcheck.sh'"


