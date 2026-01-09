#!/usr/bin/env bash
# Common shell configuration
# Source this from .bashrc, .zshrc, etc.

# ==========================================
# 1. Core Environment
# ==========================================
export EDITOR='vim'
export CLICOLOR=1

# ==========================================
# 2. PATH Management
# ==========================================
# Build PATH safely (add directories only if they exist)
add_to_path() {
  [ -d "$1" ] && export PATH="$1:$PATH"
}

# Add standard paths
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Add machine-specific paths if they exist
add_to_path "$HOME/.npm-global/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "$HOME/.local/share/pnpm"
add_to_path "/opt/rocm-6.4.0/bin"
add_to_path "$HOME/.lmstudio/bin"
add_to_path "/usr/local/go/bin"

# ==========================================
# 3. SSH & Keychain
# ==========================================
# Only run keychain if installed
if command -v keychain >/dev/null 2>&1; then
  # Only load if the key actually exists
  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    eval "$(keychain --eval --quiet id_ed25519)"
  fi
fi

# ==========================================
# 4. Development Tool Setup
# ==========================================
setup_development_tools() {
  # Initialize nvm if available
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# ==========================================
# 5. GCP State Management Functions
# ==========================================
gset() {
  # Define local variables and parse arguments
  local env=$1
  local identity=${2:-owner} # Default to 'owner' if identity isn't provided
  local env_upper
  env_upper=$(echo "$env" | tr '[:lower:]' '[:upper:]')
  local project_id_var="GCP_${env_upper}_PROJECT_ID"
  local project_id
  project_id=${!project_id_var}

  # Validate environment and project ID
  if [[ -z "$env" ]]; then
    echo "Usage: gset <environment> [identity]"
    echo "  environment: dev, test, prod"
    echo "  identity: sa, tf, owner (default: owner)"
    return 1
  fi

  if [[ -z "$project_id" ]]; then
    echo "Error: Environment variable $project_id_var is not set"
    return 1
  fi

  # Set environment variables
  export GCP_ENV="$env"
  export GCP_IDENTITY="$identity"
  export GOOGLE_CLOUD_PROJECT="$project_id"

  # Set active gcloud configuration
  gcloud config set project "$project_id" >/dev/null 2>&1
  
  echo "GCP environment set to: $env ($identity) - Project: $project_id"
}

# Function to show current GCP state
gshow() {
  if [[ -n "$GCP_ENV" ]]; then
    echo "Current GCP Environment: $GCP_ENV ($GCP_IDENTITY)"
    echo "Project: $GOOGLE_CLOUD_PROJECT"
  else
    echo "No GCP environment set. Use 'gset <env> [identity]' to configure."
  fi
}

# ==========================================
# 6. Initialize Development Tools
# ==========================================
setup_development_tools