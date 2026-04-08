.PHONY: test lint install uninstall help

help:
	@echo "backend-forge Makefile"
	@echo ""
	@echo "  make test       Run smoke tests"
	@echo "  make lint       Run shellcheck on all scripts"
	@echo "  make install    Install backend-forge skill"
	@echo "  make uninstall  Uninstall backend-forge skill"

test:
	@bash test.sh

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck install.sh uninstall.sh test.sh && echo "shellcheck passed"; \
	else \
		echo "shellcheck not installed — skipping (install with: brew install shellcheck)"; \
	fi

install:
	@bash install.sh

install-force:
	@bash install.sh --force

uninstall:
	@bash uninstall.sh

uninstall-force:
	@bash uninstall.sh --force
