.PHONY: test lint schema-validate check install uninstall help

help:
	@echo "backend-forge Makefile"
	@echo ""
	@echo "  make test              Run smoke tests"
	@echo "  make lint              Run shellcheck on all scripts"
	@echo "  make schema-validate   Validate all JSON files in schemas/"
	@echo "  make check             Run all checks (schema-validate + test + lint)"
	@echo "  make install           Install backend-forge skill"
	@echo "  make uninstall         Uninstall backend-forge skill"

test:
	@bash test.sh

lint: schema-validate
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck install.sh uninstall.sh test.sh && echo "shellcheck passed"; \
	else \
		echo "shellcheck not installed — skipping (install with: brew install shellcheck)"; \
	fi

check: schema-validate test lint

schema-validate:
	@echo "Validating JSON schemas in schemas/..."; \
	failed=0; \
	for f in schemas/*.json; do \
		if command -v jq >/dev/null 2>&1; then \
			jq . "$$f" >/dev/null 2>&1 && echo "  OK: $$f" || { echo "  FAIL: $$f"; failed=1; }; \
		else \
			python3 -m json.tool "$$f" >/dev/null 2>&1 && echo "  OK: $$f" || { echo "  FAIL: $$f"; failed=1; }; \
		fi; \
	done; \
	if [ "$$failed" -eq 0 ]; then echo "All schemas valid."; else echo "Schema validation failed."; exit 1; fi

install:
	@bash install.sh

install-force:
	@bash install.sh --force

uninstall:
	@bash uninstall.sh

uninstall-force:
	@bash uninstall.sh --force
