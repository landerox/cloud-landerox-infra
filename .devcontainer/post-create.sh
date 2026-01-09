#!/bin/bash
set -e
trap 'echo "❌ Error on line $LINENO"; exit 1' ERR

echo "🚀 Starting post-create configuration..."

# 1. Determine if sudo is required
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# 2. Update system pip
echo "📦 Updating pip..."
$SUDO pip install --root-user-action=ignore --upgrade pip

# 3. Install or upgrade uv
if command -v uv &> /dev/null; then
    echo "⚡ uv already installed — upgrading to latest..."
    $SUDO pip install --root-user-action=ignore --upgrade uv
else
    echo "⚡ Installing uv..."
    $SUDO pip install --root-user-action=ignore uv
fi

# Verify uv installation
if ! command -v uv &> /dev/null; then
    echo "❌ uv installation failed"
    exit 1
fi

# 4. Sync project dependencies
echo "📚 Syncing dependencies..."
uv sync --all-groups

# 5. Install Git hooks
echo "🪝 Installing pre-commit hooks..."
uv run pre-commit install

# 6. Initialize TFlint
echo "🧹 Initializing TFLint..."
tflint --init

# 7. Install Google Cloud SDK (if not present)
if ! command -v gcloud &> /dev/null; then
    echo "☁️  Installing Google Cloud SDK..."
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | $SUDO tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | $SUDO apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    $SUDO apt-get update && $SUDO apt-get install -y google-cloud-cli
else
    echo "☁️  Google Cloud SDK already installed."
fi

echo "✅ Configuration completed successfully!"
