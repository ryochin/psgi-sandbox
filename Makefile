PERL = carton exec -- perl -Ilib

perltidy:  ## Run perltidy
	find . -type f | egrep -v '(/local/)' | egrep '\.(pl|pm|psgi|t)$$' | xargs carton exec perltidy

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-32s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
