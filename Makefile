# Define variables for source scripts and destination directory
SRC_DIR := scripts
DEST_DIR := /usr/local/bin
REPO_DIR := $(shell pwd)

# List of scripts to install (with extensions)
SCRIPTS := pack-dir.sh old-grepper.sh branch-diff.sh \
	docker-checkpoint.sh is-screens.sh is-update.sh is-setup.sh is-nvim-update.sh

# Default rule (optional, just prints help)
.PHONY: all
all:
	@echo "Run 'sudo make install' to install scripts."

# Install rule
.PHONY: install
install:
	@echo "Installing scripts to $(DEST_DIR)..."
	@for script in $(SCRIPTS); do \
		src_path="$(SRC_DIR)/$$script"; \
		base_name="$$(basename $$script .sh)"; \
		dest_path="$(DEST_DIR)/$$base_name"; \
		ck_dest_path="$(DEST_DIR)/ck-$$base_name"; \
		echo "Installing $$src_path to $$dest_path..."; \
		sed 's|@@REPO_DIR@@|$(REPO_DIR)|g' "$$src_path" > "$$dest_path"; \
		chmod 755 "$$dest_path"; \
		echo "Installing $$src_path to $$ck_dest_path..."; \
		sed 's|@@REPO_DIR@@|$(REPO_DIR)|g' "$$src_path" > "$$ck_dest_path"; \
		chmod 755 "$$ck_dest_path"; \
	done
	@echo "Installation complete."

# Clean rule (optional)
.PHONY: clean
clean:
	@echo "No cleaning required for this project."
