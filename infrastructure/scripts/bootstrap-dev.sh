#!/bin/bash
#
# HabitaNexus - Bootstrap DEV wrapper
# -----------------------------------
# Orchestrates the full DEV environment setup (GitOps/ArgoCD + Harbor)
# using the canonical logging pattern from infrastructure/scripts/lib/common.sh.
#
# Every phase is a real `make dev-*` target. This wrapper does NOT change the
# deployment logic: it only adds structured logging (log_header / log_step /
# log_success) and tees ALL output (stdout + stderr) to a timestamped log file
# under logs/bootstrap/ while still streaming to the console.
#
# Usage:
#   infrastructure/scripts/bootstrap-dev.sh
#

# NOTE: do not enable `set -e` here. The original `bootstrap-dev` Makefile
# target tolerates failures in some phases (e.g. `|| true`); we preserve that
# behavior by handling exit codes per phase instead of aborting the wrapper.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# common.sh runs `set -euo pipefail`; we relax it again right after sourcing so
# the orchestration can continue across tolerant phases.
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
set +e
set +u

cd "$PROJECT_ROOT"

# ------------------------------------------------------------------
# Log file setup
# ------------------------------------------------------------------
LOG_FILE="logs/bootstrap/bootstrap-dev-$(get_timestamp).log"
ensure_dir "$(dirname "$LOG_FILE")"

# Redirect everything (stdout + stderr) through tee so the full run is captured
# in $LOG_FILE while remaining visible on the console.
exec > >(tee -a "$LOG_FILE") 2>&1

# ------------------------------------------------------------------
# Phases — mirror the original `bootstrap-dev` Makefile target order
# ------------------------------------------------------------------
TOTAL_STEPS=11

log_header "HabitaNexus :: Bootstrap DEV (GitOps/ArgoCD + Harbor)"
log_info "Project root : $PROJECT_ROOT"
log_info "Log file     : $PROJECT_ROOT/$LOG_FILE"

# run_phase <current> <message> <make-target> [tolerate-failure]
run_phase() {
	local current="$1"
	local message="$2"
	local target="$3"
	local tolerate="${4:-false}"

	log_step "$current" "$TOTAL_STEPS" "$message"
	if make "$target"; then
		log_success "[$current/$TOTAL_STEPS] $message — done"
	else
		local code=$?
		if [[ "$tolerate" == "true" ]]; then
			log_warn "[$current/$TOTAL_STEPS] $message — failed (exit $code), continuing (tolerated)"
		else
			log_error "[$current/$TOTAL_STEPS] $message — failed (exit $code)"
			log_error "Bootstrap aborted. See log: $PROJECT_ROOT/$LOG_FILE"
			exit "$code"
		fi
	fi
}

# Phase 1: clean previous cluster (tolerated — `|| true` in original)
run_phase 1  "Clean previous minikube cluster"   dev-minikube-destroy        true
# Phase 2: clean local terraform state
run_phase 2  "Clean local terraform state"        dev-terraform-clean
# Phase 3: first-time setup (flutter deps + codegen)
run_phase 3  "Setup (deps + codegen)"             setup
# Phase 4: create minikube cluster
run_phase 4  "Create minikube cluster"            dev-minikube-deploy
# Phase 5: fallback secret
run_phase 5  "Create fallback secret"             dev-fallback-secret
# Phase 6: terraform resources (PostgreSQL + Gateway API)
run_phase 6  "Deploy terraform resources"         dev-terraform-deploy
# Phase 7: gateway API
run_phase 7  "Deploy Gateway API"                 dev-gateway-deploy
# Phase 8: harbor registry
run_phase 8  "Deploy Harbor registry"             dev-harbor-deploy
# Phase 9: build container images
run_phase 9  "Build container images"             dev-images-build
# Phase 10: GitOps push + ArgoCD deploy
run_phase 10 "GitOps push + ArgoCD deploy"        dev-argocd-push-and-deploy
# Phase 11: start gateway port-forward
run_phase 11 "Start gateway port-forward"         dev-gateway-start

log_success "Bootstrap DEV completed. Full log: $PROJECT_ROOT/$LOG_FILE"
