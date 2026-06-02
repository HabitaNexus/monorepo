# HabitaNexus Monorepo - Automation Makefile
# ==========================================
#
# Naming Convention: env-recurso-verbo
# Examples:
#   make dev-mobile-launch       # Launch Flutter mobile app
#   make dev-terraform-deploy    # Deploy terraform resources in dev
#   make dev-argocd-deploy       # Deploy ArgoCD in dev
#   make bootstrap-dev           # Full dev environment setup (GitOps + Harbor)
#
# Usage:
#   make <target> [ENV=<environment>]
#   make help

TIMEOUT ?= 900000

.PHONY: help setup bootstrap-dev \
        dev-minikube-deploy dev-minikube-clear dev-minikube-destroy \
        dev-terraform-deploy dev-terraform-destroy dev-terraform-clean \
        dev-argocd-deploy dev-argocd-destroy dev-argocd-status dev-argocd-password \
        dev-argocd-push-and-deploy dev-argocd-sync-local dev-argocd-setup-local-repo \
        dev-harbor-deploy dev-harbor-destroy \
        dev-gateway-deploy dev-gateway-start dev-gateway-stop \
        dev-images-build dev-fallback-secret \
        dev-mobile-launch dev-mobile-analyze dev-mobile-test dev-mobile-lint \
        dev-mobile-build-runner dev-mobile-clean \
        dev-b2g-start dev-b2g-stop \
        dev-admin-start dev-admin-stop \
        ci-mobile-build ci-mobile-test

# ==========================================
# Variables
# ==========================================

ENV ?= dev
TF_DIR = infrastructure/terraform/environments/$(ENV)
SCRIPTS_DIR = infrastructure/scripts
APPS_DIR = apps
MOBILE_DIR = $(APPS_DIR)/mobile
B2G_DIR = $(APPS_DIR)/web/b2g
ADMIN_DIR = $(APPS_DIR)/web/admin
REPO_URL ?= https://github.com/HabitaNexus/monorepo.git
VERSION ?= $(shell git describe --tags --always 2>/dev/null || echo "dev")
GIT_SHA ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
IMAGE_TAG = $(VERSION)-$(GIT_SHA)
GITHUB_REGISTRY = ghcr.io/habitanexus

BLUE := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
NC := \033[0m

# ==========================================
# Help
# ==========================================

help: ## Show this help
	@echo ""
	@echo "$(GREEN)HabitaNexus Monorepo$(NC) v$(VERSION)"
	@echo ""
	@echo "$(YELLOW)Quick Start (GitOps/ArgoCD + Harbor Registry):$(NC)"
	@echo "  make bootstrap-dev"
	@echo ""
	@echo "  $(YELLOW)Step by step (Manual):$(NC)"
	@echo "  1. make setup                    $(BLUE)# First time setup$(NC)"
	@echo "  2. make dev-minikube-deploy      $(BLUE)# Create minikube cluster$(NC)"
	@echo "  3. make dev-terraform-deploy     $(BLUE)# Deploy PostgreSQL + Gateway API$(NC)"
	@echo "  4. make dev-images-build         $(BLUE)# Build all images$(NC)"
	@echo "  5. make dev-argocd-push-and-deploy $(BLUE)# Deploy with ArgoCD$(NC)"
	@echo "  6. make dev-gateway-start        $(BLUE)# Start port-forward$(NC)"
	@echo ""
	@echo "  $(YELLOW)After setup:$(NC)"
	@echo "  make dev-mobile-launch           $(BLUE)# Launch Flutter app$(NC)"
	@echo ""
	@echo "$(GREEN)DEV - Minikube:$(NC)"
	@echo "  $(YELLOW)dev-minikube-deploy$(NC)         Create minikube cluster"
	@echo "  $(YELLOW)dev-minikube-clear$(NC)          Clear stuck namespaces (finalizers)"
	@echo "  $(YELLOW)dev-minikube-destroy$(NC)        Delete minikube cluster"
	@echo ""
	@echo "$(GREEN)DEV - Terraform:$(NC)"
	@echo "  $(YELLOW)dev-terraform-deploy$(NC)        Deploy all terraform resources"
	@echo "  $(YELLOW)dev-terraform-destroy$(NC)       Destroy all terraform resources"
	@echo "  $(YELLOW)dev-terraform-clean$(NC)         Clean local terraform state"
	@echo ""
	@echo "$(GREEN)DEV - ArgoCD:$(NC)"
	@echo "  $(YELLOW)dev-argocd-deploy$(NC)           Install ArgoCD + all apps"
	@echo "  $(YELLOW)dev-argocd-destroy$(NC)          Remove ArgoCD namespace"
	@echo "  $(YELLOW)dev-argocd-status$(NC)           Show ArgoCD applications"
	@echo "  $(YELLOW)dev-argocd-password$(NC)         Get ArgoCD admin password"
	@echo "  $(YELLOW)dev-argocd-push-and-deploy$(NC)  Push changes + GitOps deploy"
	@echo "  $(YELLOW)dev-argocd-sync-local$(NC)       Sync from local filesystem (no push)"
	@echo ""
	@echo "$(GREEN)DEV - Harbor Registry:$(NC)"
	@echo "  $(YELLOW)dev-harbor-deploy$(NC)           Deploy Harbor registry"
	@echo "  $(YELLOW)dev-harbor-destroy$(NC)          Remove Harbor registry"
	@echo ""
	@echo "$(GREEN)DEV - Gateway:$(NC)"
	@echo "  $(YELLOW)dev-gateway-deploy$(NC)          Deploy Gateway API"
	@echo "  $(YELLOW)dev-gateway-start$(NC)           Start port-forward"
	@echo "  $(YELLOW)dev-gateway-stop$(NC)            Stop port-forward"
	@echo ""
	@echo "$(GREEN)DEV - Mobile:$(NC)"
	@echo "  $(YELLOW)dev-mobile-launch$(NC)           Launch Flutter app (Android/Desktop)"
	@echo "  $(YELLOW)dev-mobile-analyze$(NC)          Run dart analyze"
	@echo "  $(YELLOW)dev-mobile-test$(NC)             Run Flutter tests"
	@echo "  $(YELLOW)dev-mobile-lint$(NC)             Run flutter_lints"
	@echo "  $(YELLOW)dev-mobile-build-runner$(NC)     Run build_runner (codegen)"
	@echo "  $(YELLOW)dev-mobile-clean$(NC)            Clean build artifacts"
	@echo ""
	@echo "$(GREEN)DEV - Web B2G (Municipal Dashboard):$(NC)"
	@echo "  $(YELLOW)dev-b2g-start$(NC)               Start B2G dev server"
	@echo "  $(YELLOW)dev-b2g-stop$(NC)                Stop B2G dev server"
	@echo ""
	@echo "$(GREEN)CI:$(NC)"
	@echo "  $(YELLOW)ci-mobile-build$(NC)             Build mobile APK"
	@echo "  $(YELLOW)ci-mobile-test$(NC)              Run tests in CI"
	@echo ""

# ==========================================
# Setup
# ==========================================

setup: ## First-time setup: install dependencies
	@echo "$(GREEN)Setting up HabitaNexus development environment...$(NC)"
	@echo "$(BLUE)Checking Flutter...$(NC)"
	@flutter --version || (echo "$(RED)Flutter not found. Install from https://flutter.dev$(NC)" && exit 1)
	@echo "$(BLUE)Installing mobile dependencies...$(NC)"
	@cd $(MOBILE_DIR) && flutter pub get
	@echo "$(BLUE)Running code generation...$(NC)"
	@cd $(MOBILE_DIR) && dart run build_runner build --delete-conflicting-outputs || true
	@echo "$(GREEN)Setup complete!$(NC)"

# ==========================================
# DEV - Bootstrap (GitOps/ArgoCD + Harbor)
# ==========================================

bootstrap-dev: ## Full setup with GitOps/ArgoCD and Harbor Registry
	@echo "$(RED)Cleaning previous DEV environment...$(NC)"
	@$(MAKE) dev-minikube-destroy || true
	@$(MAKE) dev-terraform-clean
	@$(MAKE) setup
	@$(MAKE) dev-minikube-deploy
	@$(MAKE) dev-fallback-secret
	@$(MAKE) dev-terraform-deploy
	@$(MAKE) dev-gateway-deploy
	@$(MAKE) dev-harbor-deploy
	@$(MAKE) dev-images-build
	@$(MAKE) dev-argocd-push-and-deploy
	@$(MAKE) dev-gateway-start

# ==========================================
# DEV - Minikube
# ==========================================

images-pull: ## Pull all third-party container images required by minikube (run after `podman system prune`)
	podman pull gcr.io/k8s-minikube/kicbase:v0.0.50

dev-minikube-deploy: ## Create minikube cluster
	@$(SCRIPTS_DIR)/start-minikube.sh

dev-minikube-clear: ## Clear stuck namespaces (remove finalizers)
	@echo "$(BLUE)Clearing stuck namespaces...$(NC)"
	@for ns in $$(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do \
		if kubectl get ns $$ns -o jsonpath='{.status.phase}' 2>/dev/null | grep -q "Terminating"; then \
			echo "$(YELLOW)Clearing finalizers from namespace: $$ns$(NC)"; \
			kubectl patch ns $$ns --type merge -p '{"metadata":{"finalizers":[]}}' 2>/dev/null || true; \
		fi; \
	done
	@echo "$(GREEN)Namespace cleanup complete$(NC)"

dev-minikube-destroy: ## Delete minikube cluster
	@echo "$(RED)Deleting minikube cluster...$(NC)"
	@minikube delete 2>/dev/null || true
	@echo "$(GREEN)Minikube deleted$(NC)"

# ==========================================
# DEV - Terraform
# ==========================================

dev-terraform-deploy: ## Deploy all terraform resources (two-phase for Gateway CRDs)
	@echo "$(BLUE)Deploying DEV terraform resources (phase 1/2: CRDs bootstrap)...$(NC)"
	@cd $(TF_DIR) && tofu init && tofu apply -target=module.gateway_api -auto-approve -compact-warnings 2>/dev/null || echo "$(YELLOW)Phase 1 skipped (no gateway module yet)$(NC)"
	@echo "$(BLUE)Deploying DEV terraform resources (phase 2/2: full apply)...$(NC)"
	@cd $(TF_DIR) && tofu apply -auto-approve -compact-warnings 2>/dev/null || echo "$(YELLOW)Terraform not configured yet$(NC)"

dev-terraform-destroy: ## Destroy all terraform resources
	@echo "$(RED)Destroying DEV terraform resources...$(NC)"
	@cd $(TF_DIR) && tofu destroy 2>/dev/null || echo "$(YELLOW)Nothing to destroy$(NC)"

dev-terraform-clean: ## Clean local terraform state
	@echo "$(BLUE)Cleaning terraform state...$(NC)"
	@rm -rf $(TF_DIR)/.terraform $(TF_DIR)/terraform.tfstate* $(TF_DIR)/.terraform.lock.hcl 2>/dev/null || true
	@echo "$(GREEN)Terraform state cleaned$(NC)"

# ==========================================
# DEV - ArgoCD
# ==========================================

dev-argocd-deploy: ## Install ArgoCD + bootstrap all apps
	@echo "$(BLUE)Deploying ArgoCD...$(NC)"
	@$(SCRIPTS_DIR)/setup-argocd-dev.sh "$(REPO_URL)"
	@echo "$(GREEN)ArgoCD deployed$(NC)"

dev-argocd-destroy: ## Remove ArgoCD namespace
	@echo "$(RED)Destroying ArgoCD...$(NC)"
	@kubectl delete namespace argocd --ignore-not-found=true --wait=false
	@echo "$(GREEN)ArgoCD namespace deleted$(NC)"

dev-argocd-status: ## Show ArgoCD applications
	@export PATH="$$HOME/.local/bin:$$PATH"
	@echo "$(BLUE)ArgoCD Applications:$(NC)"
	@kubectl get applications -n argocd 2>/dev/null || echo "$(YELLOW)No applications found or ArgoCD not installed$(NC)"

dev-argocd-password: ## Get ArgoCD admin password
	@export PATH="$$HOME/.local/bin:$$PATH"
	@echo "$(BLUE)ArgoCD Admin Password:$(NC)"
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' 2>/dev/null | base64 -d && echo || echo "$(YELLOW)ArgoCD not installed$(NC)"

dev-argocd-push-and-deploy: ## Push changes and deploy with ArgoCD (GitOps)
	@export PATH="$$HOME/.local/bin:$$PATH" && $(SCRIPTS_DIR)/install-argocd-cli.sh 2>/dev/null || true
	@echo "$(BLUE)Pushing changes to origin...$(NC)"
	@git add -A && git commit -m "chore: dev deployment $(shell date +%Y%m%d-%H%M%S)" 2>/dev/null || true
	@git push origin main 2>/dev/null || echo "$(YELLOW)No changes to push$(NC)"
	@echo "$(BLUE)Deploying ArgoCD applications...$(NC)"
	@export PATH="$$HOME/.local/bin:$$PATH" && $(SCRIPTS_DIR)/setup-argocd-dev.sh "$(REPO_URL)" 2>/dev/null || true
	@echo "$(GREEN)GitOps deployment complete$(NC)"

dev-argocd-sync-local: ## Sync ArgoCD apps from local filesystem (no push)
	@export PATH="$$HOME/.local/bin:$$PATH" && $(SCRIPTS_DIR)/install-argocd-cli.sh 2>/dev/null || true
	@if ! kubectl get namespace argocd >/dev/null 2>&1; then \
		echo "$(YELLOW)ArgoCD not installed, installing...$(NC)"; \
		$(SCRIPTS_DIR)/setup-argocd-dev.sh "$(REPO_URL)"; \
	fi
	@echo "$(BLUE)Syncing from local filesystem...$(NC)"
	@echo "$(GREEN)Local sync complete$(NC)"

dev-argocd-setup-local-repo: ## Configure ArgoCD with local file:// repo (emergency)
	@$(SCRIPTS_DIR)/setup-argocd-local-repo.sh 2>/dev/null || echo "$(YELLOW)Script not found$(NC)"

# ==========================================
# DEV - Harbor Registry
# ==========================================

dev-harbor-deploy: ## Deploy Harbor registry
	@echo "$(BLUE)Deploying Harbor registry...$(NC)"
	@$(SCRIPTS_DIR)/setup-harbor.sh 2>/dev/null || echo "$(YELLOW)Harbor setup script not found$(NC)"
	@echo "$(GREEN)Harbor deployed$(NC)"

dev-harbor-destroy: ## Remove Harbor registry
	@echo "$(RED)Destroying Harbor...$(NC)"
	@kubectl delete namespace harbor --ignore-not-found=true --wait=false
	@echo "$(GREEN)Harbor removed$(NC)"

# ==========================================
# DEV - Gateway
# ==========================================

dev-gateway-deploy: ## Deploy Gateway API
	@echo "$(BLUE)Deploying Gateway API...$(NC)"
	@$(SCRIPTS_DIR)/setup-gateway.sh 2>/dev/null || echo "$(YELLOW)Gateway setup script not found$(NC)"

dev-gateway-start: ## Start port-forward
	@echo "$(BLUE)Starting port-forward...$(NC)"
	@$(SCRIPTS_DIR)/start-port-forward.sh 2>/dev/null || echo "$(YELLOW)Port-forward script not found$(NC)"

dev-gateway-stop: ## Stop port-forward
	@pkill -f "kubectl port-forward" 2>/dev/null || true
	@echo "$(GREEN)Port-forward stopped$(NC)"

# ==========================================
# DEV - Images
# ==========================================

dev-images-build: ## Build all container images
	@echo "$(BLUE)Building all images...$(NC)"
	@$(SCRIPTS_DIR)/build-images.sh 2>/dev/null || echo "$(YELLOW)Build script not found$(NC)"

dev-fallback-secret: ## Create fallback secret (when Infisical unavailable)
	@echo "$(BLUE)Creating fallback secret...$(NC)"
	@kubectl create namespace habitanexus-$(ENV) --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
	@kubectl create secret generic habitanexus-secrets -n habitanexus-$(ENV) --from-literal=placeholder=true --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true

# ==========================================
# DEV - Mobile
# ==========================================

dev-mobile-launch: ## Launch Flutter app
	@cd $(MOBILE_DIR) && flutter run

dev-mobile-analyze: ## Run dart analyze
	@cd $(MOBILE_DIR) && dart analyze

dev-mobile-test: ## Run Flutter tests
	@cd $(MOBILE_DIR) && flutter test

dev-mobile-lint: ## Run linter
	@cd $(MOBILE_DIR) && dart analyze --fatal-infos

dev-mobile-build-runner: ## Run build_runner (Riverpod, Freezed, GoRouter codegen)
	@cd $(MOBILE_DIR) && dart run build_runner build --delete-conflicting-outputs

dev-mobile-clean: ## Clean build artifacts
	@cd $(MOBILE_DIR) && flutter clean && flutter pub get

# ==========================================
# DEV - Web B2G (Municipal Dashboard)
# ==========================================

dev-b2g-start: ## Start B2G dev server
	@echo "$(YELLOW)B2G not scaffolded yet. Sprint 8.$(NC)"

dev-b2g-stop: ## Stop B2G dev server
	@echo "$(YELLOW)B2G not scaffolded yet. Sprint 8.$(NC)"

# ==========================================
# DEV - Web Admin
# ==========================================

dev-admin-start: ## Start Admin panel dev server
	@echo "$(YELLOW)Admin panel not scaffolded yet.$(NC)"

dev-admin-stop: ## Stop Admin panel dev server
	@echo "$(YELLOW)Admin panel not scaffolded yet.$(NC)"

# ==========================================
# CI
# ==========================================

ci-mobile-build: ## Build mobile APK
	@cd $(MOBILE_DIR) && flutter build apk --release

ci-mobile-test: ## Run tests in CI mode
	@cd $(MOBILE_DIR) && flutter test --coverage

# ==========================================
# Trustless Work packages
# ==========================================

TW_CORE := packages/trustless_work_dart
TW_STORAGE := packages/trustless_work_flutter_storage

.PHONY: trustless-work-test trustless-work-analyze trustless-work-format trustless-work-ci

trustless-work-test: ## Run tests for both trustless-work packages (core + storage sibling)
	cd $(TW_CORE) && dart run build_runner build --delete-conflicting-outputs && dart test --exclude-tags integration
	cd $(TW_STORAGE) && flutter test

trustless-work-analyze: ## Analyze both trustless-work packages
	cd $(TW_CORE) && dart analyze
	cd $(TW_STORAGE) && flutter analyze

trustless-work-format: ## Format both trustless-work packages
	dart format $(TW_CORE) $(TW_STORAGE)

trustless-work-ci: trustless-work-format trustless-work-analyze trustless-work-test ## Run the full local CI equivalent for trustless-work packages
