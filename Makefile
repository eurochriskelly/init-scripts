# Define variables for source scripts and destination directory
SRC_DIR := scripts
DEST_DIR := /usr/local/bin

# List of scripts to install (with extensions)
SCRIPTS := pack-dir.sh old-grepper.sh branch-diff.sh # foo-bar.sh # add files here

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
		dest_path="$(DEST_DIR)/$$(basename $$script .sh)"; \
		echo "Installing $$src_path to $$dest_path..."; \
		install -m 755 "$$src_path" "$$dest_path"; \
	done
	@echo "Installation complete."

# Clean rule (optional)
.PHONY: clean
clean:
	@echo "No cleaning required for this project."
