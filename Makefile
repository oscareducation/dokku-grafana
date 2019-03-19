SHELL=/bin/bash

shellcheck:
ifeq ($(shell shellcheck > /dev/null 2>&1 ; echo $$?),127)
ifeq ($(shell uname),Darwin)
	brew install shellcheck
else
	sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse'
	sudo apt-get update -qq && sudo apt-get install -qq -y shellcheck
endif
endif

lint:
	# these are disabled due to their expansive existence in the codebase. we should clean it up though
	# SC1090: Can't follow non-constant source. Use a directive to specify location.
	# SC2034: Variable appears unused. Verify it or export it.
	# SC2155: Declare and assign separately to avoid masking return values.
	@echo Linting...
	@$(QUIET) find ./ -maxdepth 1 -not -path '*/\.*' | xargs file | egrep "shell|bash" | awk '{ print $$1 }' | sed 's/://g' | xargs shellcheck -e SC1090,SC2034,SC2155
