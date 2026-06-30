default: help

.PHONY: help
help: ## List makefile targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: vendor
vendor: ## vendor
	rm -rf vendor
	cargo vendor --versioned-dirs -v
	# -s crates/ironic-templates/Cargo.toml
	# -s sqlx-deps/Cargo.toml

.PHONY: vendor-filterer
vendor-filterer: ## vendor-filterer
	rm -rf vendor
	cargo vendor-filterer --versioned-dirs \
	-s Cargo.toml

.PHONY: compress
compress: ## Compress vendor as tar.xz
	[[ -f vendor.tar.xz ]] && rm -f vendor.tar.xz || true
	XZ_OPT='-9e -T0' tar -cJf "vendor.tar.xz" vendor/

.PHONY: upgrade
upgrade: ## Update Dependencies
	cargo upgrade -v
