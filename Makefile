# Makefile for installing dependencies and deploying configurations

INSTALL_SCRIPT = install.sh
DEPLOY_SCRIPT = deploy.sh
CLEANUP_SCRIPT = $(HOME)/scripts/cleanup.sh

PACKAGES_FILE = PACKAGES
MANIFEST_FILE = MANIFEST

# Default target
all: install deploy

# Install configurations
install:
	@echo "Making sure scripts are executable..."	
	@chmod +x $(INSTALL_SCRIPT) $(DEPLOY_SCRIPT) $(CLEANUP_SCRIPT)
	@echo "Running $(INSTALL_SCRIPT)..."
	@bash $(INSTALL_SCRIPT) $(PACKAGES_FILE)

# Deploy configurations
deploy:
	@echo "Running $(DEPLOY_SCRIPT)..."
	@bash $(DEPLOY_SCRIPT)

# Cleaning
clean:
	@echo "Cleaning up..."
	@bash $(CLEANUP_SCRIPT)

.PHONY: all install deploy clean
